//
//  ApiEndPointType.swift
//  RepoKit
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

import Alamofire

protocol ApiEndPointType {

    // MARK: - Vars & Lets
    var baseUrl: String { get }
    var path: String { get }
    var url: URL { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}
