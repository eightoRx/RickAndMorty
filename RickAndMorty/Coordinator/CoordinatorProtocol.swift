//
//  Coordinator.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

enum CoordinatorType {
    case launch
    case episode
    case favourite
    case app
    case tabBar
}

protocol Coordinator: AnyObject {
    var dependencies: IDependencies { get }
    var coordinatorFinishDelegate: CoordinatorFinishDelegate? { get }
    var childCoordinators: [Coordinator] { get set }
    var coordinatorType: CoordinatorType { get }
    var navigationController: UINavigationController { get }
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        coordinatorFinishDelegate?.coordinatorFinishDelegate(childCoordinator: self)
        print(childCoordinators)
    }
}
