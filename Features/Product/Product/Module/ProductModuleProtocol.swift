//
//  ProductModuleProtocol.swift
//  Products
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

import DesignKit
import RepoKit

public protocol ProductModuleProtocol {
    var repository: ProductRepository { get set }
    func productScreen() -> BaseNavigationController
}

extension Dependencies {

    // MARK: - Now we can obtain Product Module
    public var productModule: ProductModuleProtocol {
        return resolve(ProductModuleProtocol.self)!
    }
}
