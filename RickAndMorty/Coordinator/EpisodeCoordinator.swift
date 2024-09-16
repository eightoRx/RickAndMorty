//
//  EpisodeCoordinator.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

class EpisodeCoordinator: Coordinator {
    
    var coordinatorType: CoordinatorType {.episode}
    var dependencies: IDependencies
    var navigationController = UINavigationController()
    var coordinatorFinishDelegate: CoordinatorFinishDelegate?
    var childCoordinator = [Coordinator]()
    
    init(dependencies: IDependencies) {
        self.dependencies = dependencies
    }
    
    func start() {
        navigationController.setViewControllers([
            EpisodeAssembly.configure(dependencies)],
            animated: false
        )
    }
}
