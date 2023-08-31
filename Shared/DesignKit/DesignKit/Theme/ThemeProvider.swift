//
//  ThemeProvider.swift
//  DesignKit
//
//  Created by Mushfiq Humayoon on 05/07/23.
//

import Foundation

public protocol ThemeProvider: AnyObject {
    var theme: Theme { get }
    func register<T: Themeable>(observer: T)
    func changeTheme()
}

public class DefaultThemeProvider: NSObject, ThemeProvider {
    static let shared = DefaultThemeProvider()
    public let theme: Theme = .adaptive

    private override init() {
        super.init()
    }

    public func register<Observer: Themeable>(observer: Observer) {
        observer.apply(theme: theme)
    }

    public func changeTheme() {
        assertionFailure("The function \(DefaultThemeProvider.self).\(#function) shouldn't be used above iOS 13!")
    }
}
