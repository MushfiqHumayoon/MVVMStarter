//
//  NSNotificationName+Extension.swift
//  RepoKit
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

import Foundation

extension NSNotification.Name {
    public static let DidFinishDownloading = NSNotification.Name(rawValue: "DidFinishDownloading")
    public static let DidCompleteWithError = NSNotification.Name(rawValue: "DidCompleteWithError")
    public static let DownloadProgress = NSNotification.Name(rawValue: "DownloadProgress")
}
