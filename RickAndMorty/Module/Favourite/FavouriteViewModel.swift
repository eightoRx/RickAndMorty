//
//  FavouriteViewModel.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import Foundation
import Combine

protocol FavouriteViewModelProtocol {
    
    typealias MainDataFavourite = [MainDataEpisode]
    var mainDataFavourite: MainDataFavourite {get}
    var mainDataPublished: Published<MainDataFavourite> {get}
    var mainDataPublisher: Published<MainDataFavourite>.Publisher {get}
    
    
    func getFavouriteEpisode()
    func getChangingDataUserDefaults()
    func updateEpisode(for episode: MainDataEpisode)
    func selectCharacterID(id: Int)
}

class FavouriteViewModel: FavouriteViewModelProtocol {
    
    private let userDefaults: UserDefaultsRepositoryProtocol
    
    @Published var mainDataFavourite: MainDataFavourite = []
    var mainDataPublished: Published<MainDataFavourite> { _mainDataFavourite }
    var mainDataPublisher: Published<MainDataFavourite>.Publisher { $mainDataFavourite }
    
    var anyCancellables = Set<AnyCancellable>()
    
    init(_ dependencies: IDependencies) {
        userDefaults = dependencies.userDefaultsRepository
    }
    
    func getChangingDataUserDefaults() {
        NotificationCenter.default.publisher(for: .episodeNotification)
            .sink { [weak self] _ in
                self?.getFavouriteEpisode()
            }.store(in: &anyCancellables)
    }
    
    func getFavouriteEpisode() {
        userDefaults.getFavouriteEpisode()
            .sink(receiveCompletion: { _ in
                print("Favourite completion")
            }, receiveValue: { data in
                for episode in data {
                    if !self.mainDataFavourite.contains(where: {$0.episodeID == episode.episodeID}) {
                        self.mainDataFavourite.append(episode)
                    } else {
                        self.mainDataFavourite.removeAll(where: {$0.episodeID == episode.episodeID})
                    }
                }
            }).store(in: &anyCancellables)
    }
    
    func updateEpisode(for episode: MainDataEpisode) {
        guard let index = mainDataFavourite.firstIndex(where: { $0.episodeID == episode.episodeID }) else {return}
        mainDataFavourite[index].isFavourite.toggle()
        let updateEpisode = mainDataFavourite[index]
        
        if !updateEpisode.isFavourite {
            mainDataFavourite.remove(at: index)
        }
        userDefaults.setFavourite(mainDataFavourite)
       NotificationCenter.default.post(name: .favouriteNotification,
                                       object: nil,
                                       userInfo: ["episode" : updateEpisode])
    }
    
    func selectCharacterID(id: Int) {
        userDefaults.set(id, forKey: UserDefaultsKeys.myCharacter)
    }
}

