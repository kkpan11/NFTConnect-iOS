//
//  BaseCollectionViewProvider.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation

protocol BaseCollectionViewProviderProtocol {
    associatedtype T
    associatedtype I
    
    var dataList: [T]? { get set }
    func setupCollectionLayout()
    func didSelectItem(indexPath: I)
}


extension BaseCollectionViewProviderProtocol {
    func setupCollectionLayout() {}
    func didSelectItem(indexPath: I) {}
}
