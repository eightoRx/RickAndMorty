//
//  CoreData.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 22.10.2024.
//

import Foundation
import CoreData

typealias EpisodeCoreDataResult = Result<[Episode]?, CoreDataError>
protocol EpisodeCoreDataServiceProtocol {
    func fetch(completion: @escaping (EpisodeCoreDataResult) -> Void)
    func update(episode: [Episode])
}


class EpisodeCoreDataService: EpisodeCoreDataServiceProtocol {
    private let container: NSPersistentContainer
    private let containerName: String = CoreDataConstant.episodeContainerName
    private let entityName: String = CoreDataConstant.episodeEntityName
    private var savedEntities: [EpisodeEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetch(completion: @escaping (EpisodeCoreDataResult) -> Void) {
        let request = NSFetchRequest<EpisodeEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
            if !savedEntities.isEmpty {
                let episodes = savedEntities.map {Episode($0)}
                completion(.success(episodes))
            } else {
                completion(.success(nil))
            }
        } catch let error {
            completion(.failure(.errorFetching(error)))
        }
    }

    func update(episode: [Episode]) {
            add(episode: episode)
        }
    
    private func add(episode: [Episode]) {
        
        let existingID = Set(savedEntities.compactMap { $0.episodeID })
        episode.forEach {
            if !existingID.contains(Int16($0.id)) {
                EpisodeEntity.make(context: container.viewContext, model: $0)
            }
        }
        applyChanges()
    }
    
    private func delete(entitys: [EpisodeEntity]) {
        entitys.forEach {
            container.viewContext.delete($0)
        }
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func applyChanges() {
        save()
        fetch { _ in }
    }
}
