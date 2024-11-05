//
//  Character.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 04.10.2024.
//

import Foundation
import CoreData

struct EpisodeResponse: Codable, Hashable {
    let info: Info
    let results: [Episode]
}

struct Info: Codable, Hashable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct Episode: Codable, Hashable {
    let id: Int
    let name: String
    let episode: String
    let characters: [String]
}

// MARK: CoreData
extension Episode {
    init(_ entity: EpisodeEntity) {
        id = Int(entity.episodeID)
        name = entity.nameSeries ?? "Unkonow"
        episode = entity.numberSeries ?? "0000"
        if let characterEntitys = entity.characterURL as? [String] {
            characters = characterEntitys.map { $0 }
        } else {
            characters = []
        }
    }
}
