//
//  Theme.swift
//  DesignKit
//
//  Created by Mushfiq Humayoon on 05/07/23.
//

import UIKit

public protocol Themeable: AnyObject {
    func apply(theme: Theme)
}

public struct Theme: Equatable {

    // MARK: - Themes
//    static let light = Theme(type: .light, colors: .light)
//    public static let dark = Theme(type: .dark, colors: .dark)
//    @available(iOS 13.0, *)
    static let adaptive = Theme(type: .adaptive, colors: .adaptive)

    // MARK: - Colors
    enum `Type` {
//        case light
//        case dark
//        @available(iOS 13.0, *)
        case adaptive
    }
    let type: Type
    public let textColor: UIColor
    public let barStyle: UIBarStyle
    public let scrollIndicatorStyle: UIScrollView.IndicatorStyle
    public var primary: UIColor

    // MARK: - Init
    init(type: Type, colors: ColorPalette) {
        self.type = type
        self.textColor = colors.secondary
        self.barStyle = .default
        self.scrollIndicatorStyle = .default
        self.primary = colors.primary
    }

    // MARK: - Equating function
    public static func == (lhs: Theme, rhs: Theme) -> Bool {
        return lhs.type == rhs.type
    }
}
