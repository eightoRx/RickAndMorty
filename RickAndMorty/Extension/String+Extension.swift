//
//  String+Extension.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 23.09.2024.
//

import Foundation


extension String {
    static let collectionIdentifiere = "collectionIdentifiere"
}

extension String {
    func limitSimbol() -> String {
        if self.count > 12 {
            return "\(self.prefix(12))..."
        }
        return self
    }
}
