//
//  NFTDetailViewController.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import UIKit

protocol DetailViewControllerBehaviorally {
    associatedtype V
    associatedtype P
    func inject(viewModel: V, provider: P)
    func addObservationListener()
    func setupDetailView()
}

class NFTDetailViewController: BaseViewController, DetailViewControllerBehaviorally {
    
    typealias V = NFTDetailViewModel
    typealias P = NFTDetailViewProvider
    
    var viewModel: V!
    private var provider: P!
    @IBOutlet weak var detailView: NFTDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailView()
        addObservationListener()
        viewModel.start()
    }
    
    /// Controller's ViewModel and Provider injection.
    /// - Parameters:
    ///   - viewModel: NFTDetailViewModel
    ///   - provider: NFTDetailStackViewProvider
    func inject(viewModel: NFTDetailViewModel, provider: NFTDetailViewProvider) {
        self.viewModel = viewModel
        self.provider = provider
    }
    
    func setupDetailView() {
        provider.setupDetailView(detailView)
    }
    
    private func handleError(message: String?) {
        showToastMessage(message: message)
    }
    
    private func handleLoading(show: Bool) {
        show ? showLoading() : hideLoading()
    }
}

// MARK: - Listeners
extension NFTDetailViewController {
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
        provider.detailViewStateClosure = { [weak self] type in
            switch type {
            case .updateUI(let data):
                self?.detailViewUserActivity(event: data)
            case .error(let error):
                self?.handleError(message: error?.localizedDescription)
            }
        }
    }
}

// MARK: - ViewModel Event Handler
extension NFTDetailViewController {
    private func handleClosureData(data: NFTDetailViewModel.UserInteractivity) {
        DispatchQueue.main.async { [weak self] in
            switch data {
            case .updateData(let data):
                self?.title = data.contract.name
                self?.provider.setData(data: data)
            case .loading(let show):
                self?.handleLoading(show: show)
            case .error(let message):
                self?.handleError(message: message)
            }
        }
    }
}

// MARK: - DetailView Provider Event Handler
extension NFTDetailViewController {
    private func detailViewUserActivity(event: NFTDetailViewProvider.DetailViewUserInteractivity?) {
        guard let event = event else { return }
        switch event {
        case .openLink(let nft):
            coordinatorDelegate?.commonControllerToCoordinator(eventType: .openWeb(nft: nft))
        }
    }
}
