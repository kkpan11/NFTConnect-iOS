//
//  NFTRepository.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation

protocol NFTRepositoryProtocol {
    func list(pageSize: Int, pageKey: String?) async throws -> OwnedNFTsResponse
}

struct NFTRepository: NFTRepositoryProtocol {
    
    typealias NFTListCompletionType = (Result<OwnedNFTsResponse, Error>) -> Void
    
    func list(pageSize: Int, pageKey: String?) async throws -> OwnedNFTsResponse {
        return try await withCheckedThrowingContinuation({ continuation in
            list(pageSize: pageSize, pageKey: pageKey) { result in
                continuation.resume(with: result)
            }
        })
    }
    
    private func list(pageSize: Int, pageKey: String?, completion: @escaping NFTListCompletionType) {
        APIHandler.shared.processRequest(target: Endpoint.list(pageSize: pageSize, pageKey: pageKey)).done { (response: OwnedNFTsResponse) in
            completion(.success(response))
        }.catch { error in
            completion(.failure(error))
        }
    }
}
