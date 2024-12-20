//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 03.12.2024.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case urlError(URLError)
    case responseError(Int)
    case decodingError(DecodingError)
    case anyError
    
    var localizedDescription: String {
        switch self {
        case .urlError(let error):
            return error.localizedDescription
        case .decodingError(let error):
            return error.localizedDescription
        case .responseError(let error):
            return "Bad response code: \(error)"
        case .anyError:
            return "Unknown error has ocurred"
        }
    }
}
