//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func start()
}

final class AppCoordinator: AppCoordinatorProtocol {
    
    var coordinatorType: CoordinatorType { .app }
    var dependencies: IDependencies
    var coordinatorFinishDelegate: CoordinatorFinishDelegate?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController, dependencies: IDependencies) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
    
    func start() {
        showLaunchScreen()
    }
    
    private func showMainFlow() {
        let tabBarCoordinator = TabBarCoordinator(navigationController, dependencies: dependencies)
        tabBarCoordinator.start()
        tabBarCoordinator.coordinatorFinishDelegate = self
        childCoordinators.append(tabBarCoordinator)
    }
    
    private func showLaunchScreen() {
        let launchCoordinator = LaunchCoordinator(navigationController, dependencies: dependencies)
        launchCoordinator.start()
        launchCoordinator.coordinatorFinishDelegate = self
        childCoordinators.append(launchCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorFinishDelegate(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0.coordinatorType != childCoordinator.coordinatorType }
        switch childCoordinator.coordinatorType {
        case .launch: showMainFlow()
        case .episode, .favourite, .app, .tabBar: break
        }
    }
}
