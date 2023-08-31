//
//  Extension+Bundle.swift
//  DesignKit
//
//  Created by Mushfiq Humayoon on 31/08/23.
//

import Foundation
extension Bundle {

    // MARK: - App Display Name
    public var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }

    // MARK: - UIImage AppIcon
    public var appIcon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }

    // MARK: - Version Code
    public var versionCode: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    // MARK: - Build Number
    public var buildNumber: String? {
        return object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    // MARK: - Version Format
    public var displayAppVersionFormat: String? {
        if let version = versionCode, let buildNumber = buildNumber {
            return "V \(String(describing: version)) (\(String(describing: buildNumber)))"
        } else {
            return "V 0"
        }
    }
}
