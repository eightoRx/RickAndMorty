//
//  Character.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 04.10.2024.
//

import Foundation

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
//    let air_date: String
    let episode: String
    let characters: [String]
//    let url: String
//    let created: String
}
