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
    var childCoordinators = [Coordinator]()
    
    init(dependencies: IDependencies) {
        self.dependencies = dependencies
    }
    
   func start() {
        showViewController()
    }
    
    private func showViewController() {
        let episodeVC = EpisodeAssembly.configure(dependencies)
        let detailCharacterVC = CharacterDetailAssembly.configure(dependencies)
        guard let episodeVC = episodeVC as? EpisodeViewController else {return}
        if let detailCharacterVC = detailCharacterVC as? CharacterDetailViewController {
            
            episodeVC.detailHandler = { [weak self] event in
                switch event {
                case .moveToCharacterDetail:
                    self?.navigationController.pushViewController(detailCharacterVC, animated: true)
                }
            }
        }
        navigationController.setViewControllers([episodeVC], animated: false)
    }
}
