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
}

protocol Coordinator: AnyObject {
    var dependencies: IDependencies {get}
    var coordinatorFinishDelegate: CoordinatorFinishDelegate? {get}
    var childCoordinator: [Coordinator] {get set}
    var coordinatorType: CoordinatorType {get}
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinator.removeAll()
        coordinatorFinishDelegate?.coordinatorFinishDelegate(childCoordinator: self)
    }
}
