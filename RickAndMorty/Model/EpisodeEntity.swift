//
//  EpisodeEntity.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 30.10.2024.
//

import CoreData

extension EpisodeEntity {
    @discardableResult
    static func make(context: NSManagedObjectContext, model: Episode) -> EpisodeEntity {
        let entity = EpisodeEntity(context: context)
        entity.episodeID = Int16(model.id)
        entity.nameSeries = model.name
        entity.numberSeries = model.episode
        return entity
    }
}
