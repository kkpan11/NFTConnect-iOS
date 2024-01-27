//
//  Endpoint.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/24.
//

import Foundation
import Alamofire

enum Endpoint {
    case list(pageSize: Int, pageKey: String?)
    case opensea(contractAddress: String, tokenID: String)
}

extension Endpoint: TargetType {
    var baseURL: String {
        switch self {
        case .list:
            return AppConstants.BaseURL
        case .opensea:
            return AppConstants.TestnetsURL
        }
    }
    
    var path: String {
        switch self {
        case .list:
            return "/" + AppConstants.APIKey + "/getNFTsForOwner"
        case .opensea(let contractAddress, let tokenID):
            return "/assets/goerli/" + contractAddress + "/" + tokenID
        }   
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var request: Request {
        switch self {
        case .list(let pageSize, let pageKey):
            var params = ["pageSize" : pageSize, "owner": AppConstants.OwnerAddress] as [String : Any]
            if let pageKey = pageKey {
                params["pageKey"] = pageKey
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .opensea:
            return .requestPlain
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default:
            return [:]
        }
    }
    
}
