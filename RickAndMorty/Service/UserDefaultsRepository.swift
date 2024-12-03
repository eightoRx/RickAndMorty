//
//  UserDefaultsRepository.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 12.10.2024.
//

import Foundation
import Combine

protocol UserDefaultsRepositoryProtocol {
    func set(_ object: Any?, forKey key: String)
    func int(forKey key: String) -> Int?
    func remove(key: String)
    func getFavouriteEpisode() -> AnyPublisher<[MainDataEpisode], Error>
    func setFavourite(_ favourite: [MainDataEpisode])
}

struct UserDefaultsRepository: UserDefaultsRepositoryProtocol {
    
    private let container: UserDefaults
    
    init(container: UserDefaults) {
        self.container = container
    }
    
    func set(_ object: Any?, forKey key: String) {
        store(object, key: key)
    }
    
    func int(forKey key: String) -> Int? {
        restore(forKey: key) as? Int
    }
    
    // write data
    private func store(_ object: Any?, key: String) {
        container.set(object, forKey: key)
    }
    
    func remove(key: String) {
        container.set(nil, forKey: key)
    }
    
    // rewrite data
    private func restore(forKey key: String) -> Any? {
        container.object(forKey: key)
    }
    
    func remove(forKey key: String) {
        container.removeObject(forKey: key)
    }
    
    func getFavouriteEpisode() -> AnyPublisher<[MainDataEpisode], Error> {
        if let data = container.data(forKey: UserDefaultsKeys.favourite) {
            do {
                let favoutite = try data.decoded() as [MainDataEpisode]
                return Just(favoutite)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
        } else {
            return Fail(error: NSError(domain: "NoDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in favourite userDefaults"]))
                .eraseToAnyPublisher()
        }
    }
    
    func setFavourite(_ favourite: [MainDataEpisode]) {
        do {
            let data = try favourite.encoded()
            container.set(data, forKey: UserDefaultsKeys.favourite)
        } catch {
            print("Encoded ERROR!!!: \(error)")
        }
    }
}
