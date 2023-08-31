//
//  BaseRepository.swift
//  RepoKit
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

import Foundation

open class BaseRepository {
    public var dbManager: CoreDataStack {
        return Dependencies.shared.dbManager
    }
    public var apiManager: ApiManager {
        return Dependencies.shared.apiManager
    }
    public var downloader: DownloadManager {
        return Dependencies.shared.downloadManager
    }
    
    // MARK: - Initialization
    public init() {}

    // MARK: - Make Directory
    public func makeDirectory(for fileType: String, destination: String) {
        let documentsDirectory = destination
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent(fileType)
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
