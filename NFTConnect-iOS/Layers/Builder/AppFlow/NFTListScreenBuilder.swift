//
//  NFTListScreenBuilder.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation
import UIKit

protocol NFTListScreenBuilderProtocol {
    static func build(coordinatorDelegate: CommonControllerToCoordinatorDelegate?) -> UIViewController
}

struct NFTListScreenBuilder: NFTListScreenBuilderProtocol {
    static func build(coordinatorDelegate: CommonControllerToCoordinatorDelegate?) -> UIViewController {
        let vc = NFTListViewController(nibName: NFTListViewController.className, bundle: nil)
        vc.coordinatorDelegate = coordinatorDelegate
        
        let repo = NFTRepository()
        let store = NFTDataStore(repo: repo)
        let viewModel = NFTListViewModel(store: store)
        let provider = NFTListCollectionViewProvider()
        
        vc.inject(viewModel: viewModel, provider: provider)
        
        return vc
    }
}
