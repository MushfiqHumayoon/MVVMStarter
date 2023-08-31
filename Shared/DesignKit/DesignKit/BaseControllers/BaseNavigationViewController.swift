//
//  BaseNavigationViewController.swift
//  DesignKit
//
//  Created by Mushfiq Humayoon on 05/07/23.
//

import Foundation

open class BaseNavigationController: UINavigationController, Themeable {

    // MARK: - View Identifier
    public static func viewIdentifer() -> String {
        return String(describing: self)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    open func apply(theme: Theme) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = .clear
        navigationBar.barStyle = theme.barStyle
        navigationBar.tintColor = .white
    }
}
