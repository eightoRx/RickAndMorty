//
//  Merge.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 09.10.2024.
//

import Foundation

struct MainDataEpisode: Codable, Hashable {
    let nameSeries: String
    let numberSeries: String
    let nameCharacter: String
    let image: Data
    let characterID: Int
    let episodeID: Int
    var isFavourite: Bool = false
}
