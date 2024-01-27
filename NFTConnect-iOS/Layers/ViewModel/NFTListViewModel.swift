//
//  NFTListViewModel.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation
import CollectionConcurrencyKit

protocol NFTListViewModelProtocol {
    var stateClosure: ((ObservationType<NFTListViewModel.UserInteractivity, Error>) -> ())? { set get }
    init(store: NFTDataStore)
    func start()
    func fetchNFTList(next: Bool) async
}

final class NFTListViewModel: NFTListViewModelProtocol {
    
    actor NFTListActor {
        private var items: [NFT] = []
        /// Key: Token URI
        /// Value: NFT index in `items` array
        private var indexes: [String: Int] = [:]
        
        func setNFT(_ nft: NFT) {
            guard indexes[nft.tokenURI] == nil else { return }
            
            items.append(nft)
            indexes[nft.tokenURI] = items.count - 1
        }
        
        func getList() -> [NFT] {
            return items
        }
        
        func getItemAtIndex(_ index: Int) -> NFT? {
            guard index > items.count else { return nil }
            
            return items[index]
        }
        
        func clearList() {
            items.removeAll()
            indexes.removeAll()
        }
    }
    
    var listActor = NFTListActor()
    var stateClosure: ((ObservationType<UserInteractivity, Error>) -> ())?
    private let store: NFTDataStore
    
    init(store: NFTDataStore) {
        self.store = store
    }
    
    func start() {
        Task {
            await fetchNFTList(next: false)
        }
    }
    
    func fetchNFTList(next: Bool) async {
        stateClosure?(.updateUI(data: .loading(show: true)))
        
        do {
            let nfts = try await store.getNFTList(next: next)
            Task { @MainActor in
                stateClosure?(.updateUI(data: .loading(show: false)))
                await prepareUI(nftList: nfts, next: next)
            }
        } catch {
            stateClosure?(.error(error: error))
            stateClosure?(.updateUI(data: .loading(show: false)))
            await prepareUI(nftList: [], next: next)
        }
    }
    
    private func prepareUI(nftList: [NFT], next: Bool) async {
        if !next {
            await listActor.clearList()
        }
        
        if nftList.isEmpty {
            self.stateClosure?(.updateUI(data: .updateData(data: await listActor.getList())))
        } else {
            await nftList.asyncForEach { nft in
                await listActor.setNFT(nft)
            }
            
            Task { @MainActor in
                let nfts = await listActor.getList()
                self.stateClosure?(.updateUI(data: .updateData(data: nfts)))
            }
        }
    }
}

extension NFTListViewModel {
    enum UserInteractivity {
        case updateData(data: [NFT])
        case error(message: String?)
        case loading(show: Bool)
    }
}

