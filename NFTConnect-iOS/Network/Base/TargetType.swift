//
//  TargetType.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/24.
//

import Foundation
import Alamofire

public enum Request {
    case requestPlain
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
}

public protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var request: Request { get }
    var headers: HTTPHeaders? { get }
}
