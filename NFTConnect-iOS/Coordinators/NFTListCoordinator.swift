//
//  NFTListCoordinator.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation

final class NFTListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: BaseNavigationController
    
    init(navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let nftListVC = NFTListScreenBuilder.build(coordinatorDelegate: self)
        self.navigationController.pushViewController(nftListVC, animated: false)
    }
}

// MARK: - Controller To Coordinator
extension NFTListCoordinator: CommonControllerToCoordinatorDelegate {
    func commonControllerToCoordinator(eventType: AppFlowEventType) {
        switch eventType {
        case .nftDetail(let nft):
            goToNFTDetail(nft)
        default:
            break
        }
    }
}

// MARK: - Coordinator To Coordinator
extension NFTListCoordinator {
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

extension NFTListCoordinator {
    func goToNFTDetail(_ nft: NFT) {
        let nftDetailCoordinator = NFTDetailCoordinator(navigationController: navigationController, nft: nft)
        addChild(coordinator: nftDetailCoordinator)
        nftDetailCoordinator.callBack = { [weak self] event in
            self?.nftDetailCoordinatorEvent(event: event)
        }

        nftDetailCoordinator.start()
    }
}
