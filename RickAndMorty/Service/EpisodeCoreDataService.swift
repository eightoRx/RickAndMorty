//
//  CoreData.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 22.10.2024.
//

import Foundation
import CoreData

protocol EpisodeCoreDataServiceProtocol {
    
}


class EpisodeCoreDataService: EpisodeCoreDataServiceProtocol {
    private let container: NSPersistentContainer
    private let containerName: String = CoreDataConstant.episodeContainerName
    private let entityName: String = CoreDataConstant.episodeEntityName
    private var savedEntities: [EpisodeEntity] = []
}
