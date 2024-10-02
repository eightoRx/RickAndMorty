//
//  TabBarCoordinator.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 19.09.2024.
//

import UIKit


final class TabBarCoordinator: Coordinator {
    
    var dependencies: IDependencies
    var coordinatorFinishDelegate: CoordinatorFinishDelegate?
    var childCoordinators = [Coordinator]()
    var coordinatorType: CoordinatorType { .tabBar }
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController, dependencies: IDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let tabBarController = BaseTabBarAssembly.configure(dependencies)
        let episodeCoordinator = EpisodeCoordinator(dependencies: dependencies)
        let favouriteCoordinator = FavouriteCoordinator(dependencies: dependencies)
        
        guard let tabBar = tabBarController as? BaseTabBarController else {return}
 
        self.childCoordinators.append(episodeCoordinator)
        self.childCoordinators.append(favouriteCoordinator)
        
        episodeCoordinator.start()
        favouriteCoordinator.start()
        
        tabBarController.viewControllers = [episodeCoordinator.navigationController, favouriteCoordinator.navigationController]
        navigationController.pushViewController(tabBar, animated: true)
    }
}
