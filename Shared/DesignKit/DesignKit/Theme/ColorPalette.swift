//
//  ColorPalette.swift
//  DesignKit
//
//  Created by Mushfiq Humayoon on 05/07/23.
//

import UIKit

struct ColorPalette {
    let primary: UIColor
    let secondary: UIColor

    static let adaptive: ColorPalette = .init(
        primary: UIColor.blue,
        secondary: UIColor.black)
}
