//
//  CoreData.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 22.10.2024.
//

import Foundation
import CoreData

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

typealias EpisodeCoreDataResult = Result<[Episode]?, CoreDataError>
protocol EpisodeCoreDataServiceProtocol {
    func fetch(completion: @escaping (EpisodeCoreDataResult) -> Void)
    func update(episode: [Episode])
    func fetchSearchEpisode(text: String?, completion: @escaping (EpisodeCoreDataResult) -> Void)
    
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
                print("EpisodeCOREDATA ERROR!! \(error)")
            }
        }
    }
    
    func fetch(completion: @escaping (EpisodeCoreDataResult) -> Void) {
        let request = NSFetchRequest<EpisodeEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
            print(savedEntities)
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
    
    func fetchSearchEpisode(text: String?, completion: @escaping (EpisodeCoreDataResult) -> Void) {
        let request = NSFetchRequest<EpisodeEntity>(entityName: entityName)
        if let searchText = text, !searchText.isEmpty {
            request.predicate = NSPredicate(format: "numberSeries CONTAINS[cd] %@", searchText)
        }
        
        do {
            savedEntities = try container.viewContext.fetch(request)
            let episodes = savedEntities.map { Episode($0) }
            completion(.success(episodes))
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
            print("COREDATA SAVE ERROR \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        fetch { _ in }
    }
}
