//
//  CoreDataError.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 03.12.2024.
//

import Foundation


enum CoreDataError: LocalizedError {
    case errorLoading(Error)
    case errorFetching(Error)
    case errorSaving(Error)
    public var errorDescription: String? {
        switch self {
        case .errorFetching: return "Error fetching Entities."
        case .errorLoading(let error): return "Eror loading Core Data: \(error)"
        case .errorSaving(let error): return "Error saving to Core Data. \(error)"
        }
    }
}
