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
}

final class ModulContainer: IModuleContainer {
    private let dependecies: IDependencies
    
    required init(_ dependecies: IDependencies) {
        self.dependecies = dependecies
    }
}


extension ModulContainer {
    func getLaunchController() -> UIViewController {
        let vc = LaunchViewController()
        vc.title = "Episode Title"
        vc.tabBarItem = UITabBarItem(title: nil,
                                             image: UIImage(systemName: "house"),
                                             selectedImage: UIImage(systemName: "house.fill"))
        return vc
    }
}


extension ModulContainer {
    func getEpisodeController() -> UIViewController {
        let vc = EpisodeViewController()
        return vc
    }
}


extension ModulContainer {
    func getFavouriteController() -> UIViewController {
        let vc = FavouriteViewController()
        vc.title = "Favourite Title"
        vc.tabBarItem = UITabBarItem(title: nil,
                                             image: UIImage(systemName: "heart"),
                                             selectedImage: UIImage(systemName: "heart.fill"))
        return vc
    }
}


extension ModulContainer {
    func getCharacterDetailController() -> UIViewController {
        let vc = CharacterDetailViewController()
        return vc
    }
}
