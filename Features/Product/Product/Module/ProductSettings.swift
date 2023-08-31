//
//  ProductSettings.swift
//  Product
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

import Foundation
// MARK: - ProductSettings
public class ProductSettings {

    // MARK: - Shared Instance
    private static var sharedInstance: ProductSettings = {
        return ProductSettings()
    }()

    // MARK: - Accessor
    public static func shared() -> ProductSettings {
        return sharedInstance
    }
}
