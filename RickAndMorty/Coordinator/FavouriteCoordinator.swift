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
    var childCoordinators = [Coordinator]()
    
    init(dependencies: IDependencies) {
        self.dependencies = dependencies
    }
    
    func start() {
        showViewController()
    }
    
   private func showViewController() {
        let favouriteVC = FavouriteAssembly.configure(dependencies)
        let detailCharacterVC = CharacterDetailAssembly.configure(dependencies)
        guard let favouriteVC = favouriteVC as? FavouriteViewController else {return}
        if let detailCharacterVC = detailCharacterVC as? CharacterDetailViewController {
            
            favouriteVC.detailHandler = { [weak self] event in
                switch event {
                case .moveToCharacterDetail:
                    self?.navigationController.pushViewController(detailCharacterVC, animated: true)
                }
            }
        }
        navigationController.setViewControllers([favouriteVC], animated: false)
    }
}
