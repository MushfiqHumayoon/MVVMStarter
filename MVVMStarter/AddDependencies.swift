//
//  AddDependencies.swift
//  MVVMStarter
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

import DesignKit
import RepoKit
import Product

func configDependencies() {
    let dependencies = Dependencies.shared
    
    // MARK: - PRODUCT DEPENDENCY
    let repo = ProductRepository()
    let settings = ProductSettings.shared()
    let productModule = ProductModule(repo: repo, settings: settings)
    dependencies.register(ProductModuleProtocol.self, module: productModule)
}
