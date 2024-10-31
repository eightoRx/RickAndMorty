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
//    func set<T: Encodable>(object: T?, forKet key: String)
    
    func int(forKey key: String) -> Int?
    func remove(key: String)
    func getFavouriteEpisode() -> AnyPublisher<[MainDataEpisode], Error>
    func setFavourite(_ favourite: [MainDataEpisode])
//    func string(forKey key: String) -> String?
//    func dict(forKey key: String) -> [String: Any]?
//    func date(forKey key: String) -> Date?
//    func bool(forKey key: String) -> Bool?
//    func codableData<T: Decodable>(forKey key: String) -> T?
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
            print("No data in favourite userDefaults")
            return Fail(error: NSError(domain: "NoDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in favourite userDefaults"]))
                .eraseToAnyPublisher()
        }
    }
    
    func setFavourite(_ favourite: [MainDataEpisode]) {
        do {
            let data = try favourite.encoded()
            container.set(data, forKey: UserDefaultsKeys.favourite)
        } catch {
            print("Encoded ERROR!!!: ", error)
        }
    }
}
