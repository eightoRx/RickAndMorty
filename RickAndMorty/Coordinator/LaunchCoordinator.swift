//
//  LaunchCoordinator.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

class LaunchCoordinator: Coordinator {
    
    var coordinatorType: CoordinatorType { .launch }
    var dependencies: IDependencies
    var coordinatorFinishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    init(_ navigationController: UINavigationController, dependencies: IDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let launchVC = LaunchAssembly.configure(dependencies)
        guard let launchVC = launchVC as? LaunchViewController else { return }
        launchVC.handlerLaunch = { [weak self] event in
            switch event {
            case .launchCompleted: self?.finish()
            }
        }
        navigationController.pushViewController(launchVC, animated: false)
    }
}
