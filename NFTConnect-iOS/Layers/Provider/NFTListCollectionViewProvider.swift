//
//  NFTListCollectionViewProvider.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation
import UIKit

protocol NFTListCollectionViewProviderProtocol {
    var fechingMore: Bool { get set }
    var collectionViewStateClosure: ((ObservationType<NFTListCollectionViewProvider.CollectionViewUserInteractivity, Error>) -> ())? { get set }
    func setData(data: [NFT])
    func collectionViewReload()
    func setupCollectionView(collectionView: UICollectionView)
}


final class NFTListCollectionViewProvider: NSObject, BaseCollectionViewProviderProtocol, NFTListCollectionViewProviderProtocol {
    
    typealias T = NFT
    typealias I = IndexPath
    
    var collectionViewStateClosure: ((ObservationType<CollectionViewUserInteractivity, Error>) -> ())?
    var dataList: [T]?
    var fechingMore: Bool = false
    private var collectionView: UICollectionView?
    
    func setData(data: [NFT]) {
        dataList = data
        collectionViewReload()
    }
    
    func collectionViewReload() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
        }
    }
    
    func setupCollectionView(collectionView: UICollectionView) {
        self.collectionView = collectionView
        setupCollectionLayout()
        let cells = [NFTItemCell.self]
        collectionView.register(cellTypes: cells)
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.delegate = self

    }
    
    func setupCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView?.setCollectionViewLayout(layout, animated: true)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}

extension NFTListCollectionViewProvider {
    enum CollectionViewUserInteractivity {
        case didSelectNFT(_ nft: NFT)
        case fetchMore
    }
}

extension NFTListCollectionViewProvider: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let list = dataList,
              list.count > indexPath.item
        else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(with: NFTItemCell.self, for: indexPath)
        let nft = list[indexPath.item]
        cell.setData(name: nft.name, imageURL: nft.image.originalURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: (width / 2) - 5, height: (width / 2) - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let list = dataList,
              list.count > indexPath.item
        else { return }
        
        let nft = list[indexPath.item]
        collectionViewStateClosure?(.updateUI(data: .didSelectNFT(nft)))
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.item == (dataList?.count ?? 0) - 1 {
                collectionViewStateClosure?(.updateUI(data: .fetchMore))
            }
        }
    }
    
}
