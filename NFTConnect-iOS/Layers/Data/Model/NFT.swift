//
//  NFT.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation

struct NFT: Codable {
    let contract: Contract
    let tokenID: String
    let tokenURI: String
    let name: String
    let description: String
    let image: Image
    
    enum CodingKeys: String, CodingKey {
        case contract
        case tokenID = "tokenId"
        case tokenURI = "tokenUri"
        case name
        case description
        case image
    }
}

struct Contract: Codable {
    let name: String
    let address: String
}

struct Image: Codable {
    let cachedURL: String?
    let thumbnailURL: String?
    let pngURL: String?
    let originalURL: String
    
    enum CodingKeys: String, CodingKey {
        case cachedURL = "cachedUrl"
        case thumbnailURL = "thumbnailUrl"
        case pngURL = "pngUrl"
        case originalURL = "originalUrl"
    }
}
