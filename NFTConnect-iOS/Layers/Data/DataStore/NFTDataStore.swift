//
//  NFTDataStore.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation

protocol NFTDataStoreProtocol {
    var pageSize: Int { get set }
    var pageKey: String? { get set }
    
    func setDataConfiguration(pageSize: Int, pageKey: String?)
    func getNFTList(next: Bool) async throws -> [NFT]
}

final class NFTDataStore: NFTDataStoreProtocol {
    
    private let repo: NFTRepository
    
    var pageSize: Int = 20
    var pageKey: String?
    
    init(repo: NFTRepository) {
        self.repo = repo
    }
    
    func setDataConfiguration(pageSize: Int, pageKey: String?) {
        self.pageSize = pageSize
        self.pageKey = pageKey
    }
    
    func getNFTList(next: Bool) async throws -> [NFT] {
        if next == false {
            pageKey = nil
        } else if next == true && pageKey == nil {
            throw NFTError.noMoreData
        }
        
        let response = try await repo.list(pageSize: pageSize, pageKey: next ? pageKey : nil)
        self.pageKey = response.pageKey
        return response.ownedNFTs
    }
}
