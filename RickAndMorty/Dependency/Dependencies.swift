//
//  Dependencies.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

protocol IDependencies {
    var moduleContainer: IModuleContainer {get}
    var imagePicker: IImagePicker { get }
    var apiClient: ApiServiceProtocol { get }
    var pictureLoadService: PictureLoaderProtocol { get }
    var userDefaultsRepository: UserDefaultsRepositoryProtocol { get }
    var episodeCoreDataService: EpisodeCoreDataServiceProtocol { get }
}


final class Dependencies: IDependencies {
    lazy var moduleContainer: IModuleContainer = ModulContainer(self)
    lazy var imagePicker: IImagePicker = ImagePicker()
    lazy var apiClient: ApiServiceProtocol = CombineNetworkService()
    lazy var pictureLoadService: PictureLoaderProtocol = PictureLoaderService()
    lazy var userDefaultsRepository: UserDefaultsRepositoryProtocol = UserDefaultsRepository(container: .standard)
    lazy var episodeCoreDataService: EpisodeCoreDataServiceProtocol = EpisodeCoreDataService()
}
