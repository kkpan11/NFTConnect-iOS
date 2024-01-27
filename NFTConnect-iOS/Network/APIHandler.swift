//
//  APIHandler.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/24.
//

import Foundation
import Alamofire
import PromiseKit

final class APIHandler {
    
    let AF = Alamofire.Session.default
    static let shared = APIHandler()
    
    private init() {}
    
    private func buildParams(request: Request) -> ([String: Any], ParameterEncoding) {
        switch request {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }
    
    func processRequest<M: Codable, T: TargetType>(target: T) -> Promise<M> {
           let parameters = buildParams(request: target.request)
        
        return Promise<M> { seal in
            AF.request(target.baseURL + target.path, method: target.method, parameters: parameters.0, encoding: parameters.1, headers: target.headers).responseData { (data: DataResponse<Data, AFError>) in
                
                guard data.response?.statusCode == 200 else {
                    seal.reject(self.processError(error: .notFound, code: data.response?.statusCode))
                    return
                }
                
                switch data.result {
                case .success(let result):
                    let decoder = JSONDecoder()
                    do {
                        seal.fulfill(try decoder.decode(M.self, from: result))
                    } catch {
                        print(error)
                        seal.reject(self.processError(error: .parse, code: data.response?.statusCode))
                    }
                case .failure:
                    seal.reject(self.processError(error: .failure, code: data.response?.statusCode))
                }
            }
        }
    }
    
    // MARK: - Process Error
    private func processError(error: NFTError, code: Int?) -> NSError {
        
        let responseError =  NSError(domain: Bundle.main.bundleIdentifier ?? "", code: code ?? 0, userInfo: [NSLocalizedDescriptionKey : error.rawValue])
        
        return responseError
    }
}
