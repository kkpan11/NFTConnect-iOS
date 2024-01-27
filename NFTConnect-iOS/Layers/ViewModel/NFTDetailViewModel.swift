//
//  NFTDetailViewModel.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation

protocol NFTDetailViewModelProtocol {
    var stateClosure: ((ObservationType<NFTDetailViewModel.UserInteractivity, Error>) -> ())? { set get }
    init(nft: NFT, nftStore: NFTDataStore)
    func start()
}

final class NFTDetailViewModel: NFTDetailViewModelProtocol {
    
    var stateClosure: ((ObservationType<UserInteractivity, Error>) -> ())?
    
    private let nftStore: NFTDataStore
    private let nft: NFT
    
    init(nft: NFT, nftStore: NFTDataStore) {
        self.nft = nft
        self.nftStore = nftStore
    }
    
    func start() {
        prepareUI(nft: nft)
    }
    
    private func prepareUI(nft: NFT) {
        stateClosure?(.updateUI(data: .updateData(data: nft)))
    }
}

extension NFTDetailViewModel {
    enum UserInteractivity {
        case updateData(data: NFT)
        case error(message: String?)
        case loading(show: Bool)
    }
}
