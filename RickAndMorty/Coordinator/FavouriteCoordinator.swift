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
        showFavouriteScreen()
    }
    
    private func showFavouriteScreen() {
        let favouriteVC = FavouriteAssembly.configure(dependencies)
        guard let favouriteVC = favouriteVC as? FavouriteViewController else {return}
            favouriteVC.detailHandler = { [weak self] event in
                guard let self else {return}
                switch event {
                case .moveToCharacterDetail:
                    let detailCharacterVC = CharacterDetailAssembly.configure(self.dependencies)
                    self.navigationController.pushViewController(detailCharacterVC, animated: true)
            }
        }
        navigationController.setViewControllers([favouriteVC], animated: false)
    }
}
