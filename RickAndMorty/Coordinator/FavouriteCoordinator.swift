//
//  FavouriteCoordinator.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

class FavouriteCoordinator: Coordinator {
    
    var coordinatorType: CoordinatorType {.favourite}
    var dependencies: IDependencies
    var navigationController = UINavigationController()
    var coordinatorFinishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinator = [Coordinator]()
    
    init(dependencies: IDependencies) {
        self.dependencies = dependencies
    }
    
    func start() {
        navigationController.setViewControllers([
            FavouriteAssembly.configure(dependencies)],
            animated: false
        )
    }
}
