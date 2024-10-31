//
//  ModulContainer.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

protocol IModuleContainer {
    func getLaunchController() -> UIViewController
    func getEpisodeController() -> UIViewController
    func getFavouriteController() -> UIViewController
    func getCharacterDetailController() -> UIViewController
    func getBaseTabBarController() -> UITabBarController
}

final class ModulContainer: IModuleContainer {
   
    private let dependecies: IDependencies
    
    required init(_ dependecies: IDependencies) {
        self.dependecies = dependecies
    }
}

// MARK: - Launch
extension ModulContainer {
    func getLaunchController() -> UIViewController {
        let vc = LaunchViewController()
        return vc
    }
}

// MARK: - Episodes
extension ModulContainer {
    func getEpisodeController() -> UIViewController {
        let vc = EpisodeViewController()
        let viewModel = EpisodeViewModel(dependecies)
        vc.viewModel = viewModel
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: UIImage(systemName: SystemImageName.emptyHouse),
                                     selectedImage: UIImage(systemName: SystemImageName.fillHouse))
        
        return vc
    }
}

// MARK: - Favourites
extension ModulContainer {
    func getFavouriteController() -> UIViewController {
        let vc = FavouriteViewController()
        let viewModel = FavouriteViewModel(dependecies)
        vc.viewModel = viewModel
        vc.title = "Favourites episodes"
        vc.tabBarItem = UITabBarItem(title: nil,
                                     image: UIImage(systemName: SystemImageName.emptyHeart),
                                     selectedImage: UIImage(systemName: SystemImageName.fillHeart))
        return vc
    }
}

// MARK: - CharacterDetails
extension ModulContainer {
    func getCharacterDetailController() -> UIViewController {
        let vc = CharacterDetailViewController()
        let viewModel = CharacterDetailViewModel(dependecies)
        vc.viewModel = viewModel
        return vc
    }
}

// MARK: - TabBarController
extension ModulContainer {
    func getBaseTabBarController() -> UITabBarController {
        let tabBar = BaseTabBarController()
        return tabBar
    }
}
