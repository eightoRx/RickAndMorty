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
        showEpisodeScreen()
    }
    
    private func showEpisodeScreen() {
        let episodeVC = EpisodeAssembly.configure(dependencies)
        guard let episodeVC = episodeVC as? EpisodeViewController else {return}
        episodeVC.detailHandler = { [weak self] event in
            guard let self else {return}
            switch event {
            case .moveToCharacterDetail:
                let detailCharacterVC = CharacterDetailAssembly.configure(self.dependencies)
                self.navigationController.pushViewController(detailCharacterVC, animated: true)
            }
        }
        navigationController.setViewControllers([episodeVC], animated: false)
    }
}
