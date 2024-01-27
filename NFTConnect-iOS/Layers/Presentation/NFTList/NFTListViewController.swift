//
//  NFTListViewController.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import UIKit

protocol ListViewControllerBehaviorally {
    associatedtype V
    associatedtype P
    func inject(viewModel: V, provider: P)
    func addObservationListener()
    func setupCollectionView()
}

class NFTListViewController: BaseViewController, ListViewControllerBehaviorally {
    
    typealias V = NFTListViewModel
    typealias P = NFTListCollectionViewProvider
    
    var viewModel: V!
    private var provider: P!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        addObservationListener()
        viewModel.start()
    }
    
    /// Controller's ViewModel and Provider injection.
    /// - Parameters:
    ///   - viewModel: NFTListViewModel
    ///   - provider: NFTListCollectionViewProvider
    func inject(viewModel: V, provider: P) {
        self.viewModel = viewModel
        self.provider = provider
    }
    
    func setupCollectionView() {
        provider.setupCollectionView(collectionView: collectionView)
    }
    
    private func handleError(message: String?) {
        showToastMessage(message: message)
    }
    
    private func handleLoading(show: Bool) {
        show ? showLoading() : hideLoading()
    }
}

// MARK: - Listeners
extension NFTListViewController {
    func addObservationListener() {
        /// ViewModel listener
        viewModel.stateClosure = { [weak self] type in
            switch type {
            case .updateUI(let data):
                guard let data = data else { return }
                self?.handleClosureData(data: data)
            case .error(let error):
                self?.handleError(message: error?.localizedDescription)
            }
        }
        
        /// CollectionView provider listener
        provider.collectionViewStateClosure = { [weak self] type in
            switch type {
            case .updateUI(let data):
                self?.collectionViewUserActivity(event: data)
            case .error(let error):
                self?.handleError(message: error?.localizedDescription)
            }
        }
    }
}

// MARK: - ViewModel Event Handler
extension NFTListViewController {
    private func handleClosureData(data: NFTListViewModel.UserInteractivity) {
        DispatchQueue.main.async { [weak self] in
            switch data {
            case .updateData(let data):
                self?.provider.setData(data: data)
            case .loading(let show):
                self?.handleLoading(show: show)
            case .error(let message):
                self?.handleError(message: message)
            }
        }
    }
}

// MARK: - CollectionView Provider Event Handler
extension NFTListViewController {
    private func collectionViewUserActivity(event: NFTListCollectionViewProvider.CollectionViewUserInteractivity?) {
        guard let event = event else { return }
        switch event {
        case .didSelectNFT(let nft):
            coordinatorDelegate?.commonControllerToCoordinator(eventType: .nftDetail(nft))
        case .fetchMore:
            Task {
                await viewModel.fetchNFTList(next: true)
            }
        }
    }
}
