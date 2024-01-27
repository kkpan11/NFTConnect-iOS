//
//  NFTDetailScreenBuilder.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation
import UIKit

protocol NFTDetailScreenBuilderProtocol {
    static func build(nft: NFT, coordinatorDelegate: CommonControllerToCoordinatorDelegate?) -> UIViewController
}

struct NFTDetailScreenBuilder: NFTDetailScreenBuilderProtocol {
    static func build(nft: NFT, coordinatorDelegate: CommonControllerToCoordinatorDelegate?) -> UIViewController {
        let vc = NFTDetailViewController(nibName: NFTDetailViewController.className, bundle: nil)
        vc.coordinatorDelegate = coordinatorDelegate
        
        let repo = NFTRepository()
        let nftStore = NFTDataStore(repo: repo)
        let viewModel = NFTDetailViewModel(nft: nft, nftStore: nftStore)
        let provider = NFTDetailViewProvider()
        
        vc.inject(viewModel: viewModel, provider: provider)
        
        return vc
    }
}
