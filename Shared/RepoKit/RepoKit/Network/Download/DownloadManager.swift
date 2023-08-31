//
//  DownloadManager.swift
//  RepoKit
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

import Foundation

public protocol DownloadManagerDelegate: AnyObject {
    func updateDownloadProgress(url: URL, progress: Float)
    func downloadCompleteWithError(url: URL, error: Error?)
    func cancelDownload(with resumeData: Data, item: Any)
}

public class DownloadManager: NSObject {

    // MARK: - Vars & Lets
    private static var sharedInstance: DownloadManager = {
        return DownloadManager()
    }()

    // MARK: - DownloadManagerDelegate
     weak var delegate: DownloadManagerDelegate?

    // MARK: - Dictionary of operations
    var operations = [Int: DownloadOperation]()

    // MARK: - NSOperationQueue for downloads
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    // MARK: - Background session handler
    public var backgroundCompletionHandler: (() -> Void)?

    // MARK: - Initialization
    private override init() { }

    // MARK: - Set downloadManagerDelegate
    public func createConnection(delegate: DownloadManagerDelegate) {
        self.delegate = delegate
    }

    // MARK: - Accessor
    public class func shared() -> DownloadManager {
        return sharedInstance
    }

    // MARK: - URLSession & URLSessionConfiguration
    public lazy var session: URLSession = {
        let identifier = Bundle.main.bundleIdentifier!
        let configuration = URLSessionConfiguration.background(withIdentifier: String("\(identifier).download"))
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    // MARK: - Add and Cancel Operations
    public func addToQueue(url: URL, item: Any) {
        let operation = DownloadOperation(session: session, url: url, of: item)
        operations[operation.task.taskIdentifier] = operation
        queue.addOperation(operation)
    }

    public func cancelAllFromQueue() {
        queue.cancelAllOperations()
    }

    public func resetAllDownloads() {
        operations.count != 0 ? operations.values.forEach { $0.cancelDownload() } : Dependencies.shared.dbManager.saveContext()
    }
    public func pauseDownload(url: URL) {
        if let operation = operations.first(where: { $0.value.task.progress.fileURL == url }),
           let currentOperation = operations[operation.key] {
            currentOperation.task.cancel { optionalResumeData in
                guard let resumeData = optionalResumeData else {
                    print("resume data is nil")
                    return
                }
                self.delegate?.cancelDownload(with: resumeData, item: currentOperation.downloadItem)
            }
        } else {
            print("Failed")
        }
    }
    public func resumeDownload(with resumeData: Data, of item: Any, and url: URL) {
        let operation = DownloadOperation(session: session, with: resumeData, of: item)
        operation.task.progress.fileURL = url
        operations[operation.task.taskIdentifier] = operation
        queue.addOperation(operation)
    }
}

// MARK: - URLSessionDownloadDelegate methods
extension DownloadManager: URLSessionDownloadDelegate {
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            self.backgroundCompletionHandler?()
            self.backgroundCompletionHandler = nil
        }
    }

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        operations[downloadTask.taskIdentifier]?.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
    }

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                           didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                           totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.currentRequest?.url else { return }
        operations[downloadTask.taskIdentifier]?.urlSession(session,
                downloadTask: downloadTask, didWriteData: bytesWritten,
                totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.delegate?.updateDownloadProgress(url: url, progress: progress)
        }
    }
}

// MARK: URLSessionTaskDelegate methods
extension DownloadManager: URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let url = task.currentRequest?.url else { return }
        if let error = error as? NSError, error.code == 2,
           let downloadItem = operations[task.taskIdentifier]?.downloadItem {
            addToQueue(url: url, item: downloadItem)
        }
        operations[task.taskIdentifier]?.urlSession(session, task: task, didCompleteWithError: error)
        operations.removeValue(forKey: task.taskIdentifier)
        DispatchQueue.main.async {
            self.delegate?.downloadCompleteWithError(url: url, error: error)
        }
    }
}
