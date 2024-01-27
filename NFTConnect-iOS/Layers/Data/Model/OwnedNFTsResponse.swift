//
//  OwnedNFTsResponse.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/25.
//

import Foundation

struct OwnedNFTsResponse: Codable {
    let ownedNFTs: [NFT]
    let totalCount: Int
    let pageKey: String?
    let validAt: BlockInfo
    
    enum CodingKeys: String, CodingKey {
        case ownedNFTs = "ownedNfts"
        case totalCount
        case pageKey
        case validAt
    }
}

struct BlockInfo: Codable {
    let blockNumber: Int
    let blockHash: String
    let blockTimestamp: String
}
