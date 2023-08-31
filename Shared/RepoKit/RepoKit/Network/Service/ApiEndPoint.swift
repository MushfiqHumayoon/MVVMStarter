//
//  ApiEndPoint.swift
//  RepoKit
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

import Foundation
import Alamofire

public enum ApiEndPoint {

    // MARK: - Endpoints
    case products
    case product(_ id: String)
}

extension ApiEndPoint: ApiEndPointType {

    // MARK: - Vars & Lets
    var baseUrl: String {
        switch self {
        case .product, .products:
            return ApiBaseUrl.products.rawValue
        }
    }

    var path: String {
        switch self {
        case .products:
            return "products"
        case .product(let id):
            return "products/\(id)"
        }
    }

    var url: URL {
        switch self {
        default: return URL(string: self.baseUrl+self.path)!
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .products, .product:
            return .get
//        case .addProducts:
//            return .post
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .products, .product:
            return ["Content-Type": "application/json"]
//        case .addProducts:
//            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .products, .product:
            return JSONEncoding.default
//        case .addProducts:
//            return URLEncoding.default
        }
    }
}
