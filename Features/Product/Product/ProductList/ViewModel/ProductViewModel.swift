//
//  ProductViewModel.swift
//  Product
//
//  Created by Mushfiq Humayoon on 31/08/23.
//

import RepoKit

class ProductViewModel {
    // MARK: - Properties
    var repository: ProductRepository
    var productList = Observable<[String]>(value: [])
    // MARK: - Init Method
    init(repo: ProductRepository) {
        self.repository = repo
        buildProductList()
    }
    private func buildProductList() {
        let products = ["iPhone 11", "iPhone 11 Pro", "iPhone 11 Pro Max",
                        "iPhone 12", "iPhone 12 Pro", "iPhone 12 Pro Max",
                        "iPhone 13", "iPhone 13 Pro", "iPhone 13 Pro Max",
                        "iPhone 14", "iPhone 14 Pro", "iPhone 14 Pro Max"]
        productList.value = products
    }
}
