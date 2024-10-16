//
//  EpisodeViewModel.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//
import Combine
import Foundation
import UIKit

protocol EpisodeViewModelProtocol: AnyObject {
    
    typealias MainDataEpisodes = [MainDataEpisode]
    var mainDataEpisode: MainDataEpisodes {get}
    var mainDataPublished: Published<MainDataEpisodes> {get}
    var mainDataPublisher: Published<MainDataEpisodes>.Publisher {get}
    
    func fetchDataForMainScreen()
    func selectCharacterID(id: Int)
    func updateEpisode(for episode: MainDataEpisode) 
}

class EpisodeViewModel: EpisodeViewModelProtocol {
    
    private var service: ApiServiceProtocol?
    private var pictureLoadService: PictureLoaderProtocol?
    private var userDefaultsRepository: UserDefaultsRepositoryProtocol?
    
    @Published private(set) var episode: [Episode] = []
    @Published private(set) var character: [Character] = []
    var anyCancellables = Set<AnyCancellable>()
    
    @Published var mainDataEpisode: MainDataEpisodes = []
    var mainDataPublished: Published<MainDataEpisodes> { _mainDataEpisode }
    var mainDataPublisher: Published<MainDataEpisodes>.Publisher { $mainDataEpisode }
    
    init (_ depedencies: IDependencies) {
        self.service = depedencies.apiClient
        self.pictureLoadService = depedencies.pictureLoadService
        self.userDefaultsRepository = depedencies.userDefaultsRepository
    }
    
    func fetchDataForMainScreen() {
        //MARK: - Fetch Episodes
        service?.fetchData(from: API.episode)
            .sink(receiveCompletion: { // refactore with error
                _ in
                print("Complition")
            }, receiveValue: { [weak self] (data: EpisodeResponse) in
                self?.episode = data.results
            }).store(in: &anyCancellables)
        
        //MARK: - Fetch Characters
        service?.fetchData(from: API.character)
            .sink(receiveCompletion: {
                _ in
                print("Complition")
            }, receiveValue: { [weak self] (data: CharacterResponse) in
                self?.character = data.results
            }).store(in: &anyCancellables)
        
        //MARK: - zip
        self.$episode.zip(self.$character)
            .sink(receiveValue: { [weak self] value in
                guard let self else {return}
                
                let episodes = value.0.shuffled()
                let characters = value.1.shuffled()
                
                for (index, episode) in episodes.enumerated() {
                    let characterName = index < characters.count ? characters[index].name : "Unknown"
                    let characterImage = index < characters.count ? characters[index].image : " "
                    let characterID = characters[index].id
                    
                    getImage(url: characterImage) { image in
                        let mainDataItem = MainDataEpisode(nameSeries: episode.name,
                                                           numberSeries: episode.episode,
                                                           nameCharacter: characterName,
                                                           image: image, 
                                                           characterID: characterID)
                        
                        self.mainDataEpisode.append(mainDataItem)
                    }
                }
            }).store(in: &anyCancellables)
    }
    
    //MARK: - Fetch Image
    private func getImage(url: String, completion: @escaping (Data) -> Void) {
        
        pictureLoadService?.loadPicture(url)
            .sink(receiveCompletion: { [weak self] complition in
                if case let .failure(error) = complition {
                    self?.handleError(error)
                }
            }, receiveValue: { (data: Data) in
                completion(data)
            }).store(in: &anyCancellables)
    }
    
    private func handleError(_ apiError: DataAPIError) {
        print("ERROR: \(apiError.localizedDescription)!!!!!")
    }
    
    func selectCharacterID(id: Int) {
        userDefaultsRepository?.set(id, forKey: UserDefaultsKeys.myCharacter)
    }
    
    func updateEpisode(for episode: MainDataEpisode) {
        if let index = mainDataEpisode.firstIndex(where: { $0.characterID == episode.characterID }) {
            mainDataEpisode[index].isFavourite.toggle()
        }
    }
}
