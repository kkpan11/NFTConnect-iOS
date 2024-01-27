//
//  BaseViewModel.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/23.
//

import Foundation

protocol BaseViewModel {
    func start()
}

enum ObservationType<T, E> {
    case updateUI(data: T? = nil)
    case error(error: E?)
}
