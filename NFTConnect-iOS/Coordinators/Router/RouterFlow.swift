//
//  RouterFlow.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation

// MARK: - Controller to Coordinator event type
enum AppFlowEventType {
    case nftDetail(_ nft: NFT)
    case openWeb(nft: NFT)
    case finishController
}

// MARK: Coordinator To Coordinator event type
enum CoordinatorEventType {
    case finishCoordinator(coordinator: Coordinator)
}
