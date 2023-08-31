//
//  Extension+UIApplication.swift
//  DesignKit
//
//  Created by Mushfiq Humayoon on 31/08/23.
//

import Foundation

extension UIApplication {

    // MARK: - Status Bar height
    public class func statusBarHeight() -> CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return height
    }
}
