//
//  DownloadOperation.swift
//  RepoKit
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

public class DownloadOperation: AsynchronousOperation {

    // MARK: - URLSessionTask instance
    var task: URLSessionDownloadTask!
    var downloadItem: Any

    // MARK: - Initialization
    init(session: URLSession, url: URL? = nil, with resumeData: Data? = nil, of item: Any) {
        self.downloadItem = item
        if let url = url {
            task = session.downloadTask(with: url)
        } else if let resumeData = resumeData {
            task = session.downloadTask(withResumeData: resumeData)
        }
        super.init()
    }

    override public func cancel() {
        task.cancel()
        super.cancel()
    }

    override public func main() {
        task.resume()
    }
}

// MARK: - URLSessionDownloadDelegate methods
extension DownloadOperation: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.currentRequest?.url else { return }
        let userInfo: [String: Any?] = ["url": url, "location": location, "item": downloadItem]
        postInfo(with: userInfo, name: .DidFinishDownloading)
    }

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                           didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                           totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.currentRequest?.url else { return }
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let userInfo: [String: Any?] = ["url": url, "progress": progress, "item": downloadItem]
        postInfo(with: userInfo, name: .DownloadProgress)
    }
}

// MARK: - URLSessionTaskDelegate methods
extension DownloadOperation: URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        defer { finish() }
        cancelDownload()
    }
}

// MARK: - Post notification when application quits or download fails
extension DownloadOperation {
    func cancelDownload() {
        let userInfo: [String: Any?] = ["item": downloadItem]
        postInfo(with: userInfo, name: .DidCompleteWithError)
    }

    // MARK: - NotificationCenter posting with userInfo
    private func postInfo(with userInfo: [String: Any?], name notificationName: Notification.Name) {
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo as [AnyHashable: Any])
    }
}
