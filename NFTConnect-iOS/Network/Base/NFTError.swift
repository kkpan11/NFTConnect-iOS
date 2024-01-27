//
//  NFTError.swift
//  NFTConnect-iOS
//
//  Created by Gianni Hong on 2024/1/24.
//

import Foundation

enum NFTError: String, Error {
    case notFound = "Something went wrong!"
    case noMoreData = "No more data."
    case parse = "Error occured. Try again."
    case failure = "Try again."
}

extension NFTError: LocalizedError {
    var errorDescription: String? {
        return rawValue
    }
}
