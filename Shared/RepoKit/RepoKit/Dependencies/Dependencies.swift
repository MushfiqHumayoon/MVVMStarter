//
//  Dependencies.swift
//  RepoKit
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

public final class Dependencies: DependencyManager {
    // MARK: - Every modules via a singleton
    public static let shared = Dependencies()

    // MARK: - Common instances
    public var dbManager: CoreDataStack {
        return CoreDataStack.shared()
    }
    public var apiManager: ApiManager {
        return ApiManager.shared()
    }
    public var downloadManager: DownloadManager {
        return DownloadManager.shared()
    }
}
