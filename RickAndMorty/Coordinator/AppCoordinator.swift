//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

final class AppCoordinator: AppCoordinatorProtocol {
    
    
    var baseTabBarController: BaseTabBarController
    var coordinatorType: CoordinatorType { .app }
    var dependencies: IDependencies
    var coordinatorFinishDelegate: CoordinatorFinishDelegate?
    var childCoordinator = [Coordinator]()
    
    init(_ baseTabBarController: BaseTabBarController, dependencies: IDependencies) {
        self.baseTabBarController = baseTabBarController
        self.dependencies = dependencies
    }
    
    func start() {
        let episodeCoordinator = EpisodeCoordinator(dependencies: dependencies)
        episodeCoordinator.start()
        childCoordinator.append(episodeCoordinator)
        
        let favouriteCoordinator = FavouriteCoordinator(dependencies: dependencies)
        favouriteCoordinator.start()
        childCoordinator.append(favouriteCoordinator)
    }
}
