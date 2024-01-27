//
//  NFTDetailViewProvider.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation
import UIKit

protocol NFTDetailViewProviderProtocol {
    var detailViewStateClosure: ((ObservationType<NFTDetailViewProvider.DetailViewUserInteractivity, Error>) -> ())? { get set }
    func setData(data: NFT)
    func setupDetailView(_ detailView: NFTDetailView)
}

final class NFTDetailViewProvider: NSObject, NFTDetailViewProviderProtocol, NFTDetailViewProtocol {

    var detailViewStateClosure: ((ObservationType<DetailViewUserInteractivity, Error>) -> ())?
    var nft: NFT?
    private var detailView: NFTDetailView?
    
    func setData(data: NFT) {
        self.nft = data
        detailView?.setData(nft: data)
        detailView?.layoutIfNeeded()
    }
    
    func setupDetailView(_ detailView: NFTDetailView) {
        self.detailView = detailView
        self.detailView?.delegate = self
    }
    
    func openLink() {
        guard let nft = nft else { return }
        detailViewStateClosure?(.updateUI(data: .openLink(nft: nft)))
    }
}

extension NFTDetailViewProvider {
    enum DetailViewUserInteractivity {
        case openLink(nft: NFT)
    }
}
