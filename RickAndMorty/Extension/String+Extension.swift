//
//  String+Extension.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 23.09.2024.
//

import Foundation


extension String {
    static let collectionIdentifiere = "collectionIdentifiere"
    static let tableIdentifier = "CellHeader"
    static let tableCellIdentifier = "CustomCell"
}

extension String {
    func limitSimbol() -> String {
        if self.count > 12 {
            return "\(self.prefix(12))..."
        }
        return self
    }
}

extension String {
    var isEmptyOrUnknown: String {
        self.isEmpty || self.lowercased() == "unknown" ? "Unknown" : self
    }
}

