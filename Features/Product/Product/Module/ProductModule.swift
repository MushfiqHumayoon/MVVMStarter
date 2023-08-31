//
//  ProductModule.swift
//  Products
//
//  Created by Mushfiq Humayoon on 04/07/23.
//
// swiftlint: disable force_cast

import DesignKit
import RepoKit

public class ProductModule: ProductModuleProtocol {

    public var repository: ProductRepository
    public var settings: ProductSettings

    public init(repo: ProductRepository, settings: ProductSettings) {
        self.repository = repo
        self.settings = settings
    }

    public func productScreen() -> BaseNavigationController {
        let baseViewController = UIStoryboard(
            name: "Product", bundle: AppBundle.product).instantiateInitialViewController() as! BaseNavigationController
        return baseViewController
    }
}
