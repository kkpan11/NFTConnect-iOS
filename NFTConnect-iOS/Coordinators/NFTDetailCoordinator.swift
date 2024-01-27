//
//  NFTDetailCoordinator.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation
import UIKit

final class NFTDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    var callBack: ((CoordinatorEventType) -> ())?
    var nft: NFT
    
    init(navigationController: BaseNavigationController, nft: NFT) {
        self.navigationController = navigationController
        self.nft = nft
    }
    
    func start() {
        let nftDetailVC = NFTDetailScreenBuilder.build(nft: nft, coordinatorDelegate: self)
        self.navigationController.pushViewController(nftDetailVC, animated: true)
    }
    
    func finishNFTDetailCoordinator() {
        callBack?(.finishCoordinator(coordinator: self))
    }
}


extension NFTDetailCoordinator: CommonControllerToCoordinatorDelegate {
    func commonControllerToCoordinator(eventType: AppFlowEventType) {
        switch eventType {
        case .openWeb(let nft):
            openWeb(nft: nft)
        case .finishController:
            finishNFTDetailCoordinator()
        default:
            break
        }
    }
}

// MARK: - Coordinator To Coordinator
extension NFTDetailCoordinator {
    private func resetCoordinator(coordinator: Coordinator) {
        self.removeChild(coordinator: coordinator)
    }
    
    private func nftDetailCoordinatorEvent(event: CoordinatorEventType) {
        switch event {
        case .finishCoordinator(let coordinator):
            resetCoordinator(coordinator: coordinator)
        }
    }
}

extension NFTDetailCoordinator {
    func openWeb(nft: NFT) {
        let endpoint = Endpoint.opensea(contractAddress: nft.contract.address, tokenID: nft.tokenID)
        if let url = URL(string: endpoint.baseURL + endpoint.path) {
            UIApplication.shared.open(url)
        }
    }
}
