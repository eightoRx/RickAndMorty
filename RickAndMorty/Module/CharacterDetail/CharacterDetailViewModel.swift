//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import Foundation
import Combine

protocol CharacterDetailViewModelProtocol: AnyObject {
    var updateImagePicker: IImagePicker? { get set }
    
    typealias DataCharacter = MainDataCharacter
    var dataCharacter: DataCharacter? {get}
    var characterPublished: Published<DataCharacter?> {get}
    var characterPublisher: Published<DataCharacter?>.Publisher {get}
    
    var iconCharacter: Data? {get}
    var iconCharacterPublished: Published<Data?> {get}
    var iconCharacterPublisher: Published<Data?>.Publisher {get}
    
    func getCharacterData()
}

final class CharacterDetailViewModel: CharacterDetailViewModelProtocol {
    
    @Published var dataCharacter: DataCharacter?
    var characterPublished: Published<DataCharacter?> { _dataCharacter }
    var characterPublisher: Published<DataCharacter?>.Publisher { $dataCharacter }
    @Published var character: Character?
    var anyCancellables = Set<AnyCancellable>()
    
    @Published var iconCharacter: Data?
    var iconCharacterPublished: Published<Data?> {_iconCharacter}
    var iconCharacterPublisher: Published<Data?>.Publisher {$iconCharacter}
    
    var updateImagePicker: IImagePicker?
    private var service: ApiServiceProtocol?
    private var pictureLoader: PictureLoaderProtocol?
    private var userDefaultsRepository: UserDefaultsRepositoryProtocol?
    
    init(_ dependecies: IDependencies) {
        updateImagePicker = dependecies.imagePicker
        service = dependecies.apiClient
        pictureLoader = dependecies.pictureLoadService
        userDefaultsRepository = dependecies.userDefaultsRepository
    }
    
    func getCharacterData() {
    
        guard let characterID = userDefaultsRepository?.int(forKey: UserDefaultsKeys.myCharacter) else { return }
        
        service?.fetchData(from: API.baseURL + API.character + String(characterID), page: nil)
            .sink(receiveCompletion: {
                _ in
                print("Get detail character")
            }, receiveValue: { [unowned self] (data: Character) in
                self.character = data
                self.getIconData(url: data.image)
            }).store(in: &anyCancellables)
       
        $character
            .sink(receiveValue: { [unowned self] data in
                guard let data else {return}
                let mainDataCharacter = MainDataCharacter(name: data.name,
                                                          gender: data.gender.rawValue,
                                                          status: data.status.rawValue,
                                                          specie: data.species.rawValue,
                                                          origin: data.origin.name,
                                                          type: data.type,
                                                          location: data.location.name,
                                                          icon: Data()
                )
                
                self.dataCharacter = mainDataCharacter
            }).store(in: &anyCancellables)
    }
    
    func getIconData(url: String) {
        pictureLoader?.loadPicture(url)
            .sink(receiveCompletion: {
                _ in
                print("Get image Data")
            }, receiveValue: { [weak self] (data: Data) in
                self?.iconCharacter = data
            }).store(in: &anyCancellables)
    }
}
