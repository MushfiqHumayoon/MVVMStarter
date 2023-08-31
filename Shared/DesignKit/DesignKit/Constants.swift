//
//  Constants.swift
//  DesignKit
//
//  Created by Mushfiq Humayoon on 05/07/23.
//

import Foundation

public typealias CellTapHandler = ((IndexPath) -> Void)
public typealias DismissTapHandler = (() -> Void)

public struct AppBundle {
    public static let product = Bundle(identifier: "io.gemstud.Product")!
}
