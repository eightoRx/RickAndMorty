//
//  BaseTabBarController.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

final class BaseTabBarController: UITabBarController {
    
    private let dependecies = Dependencies()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.setupControllers()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        self.tabBar.isTranslucent = true
        self.tabBar.backgroundColor = .white
        self.tabBar.itemPositioning = .centered
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = .init(gray: 0.5, alpha: 0.5)
        
    }
    
    private func setupControllers() {
        self.setViewControllers([EpisodeAssembly.configure(dependecies),
                                 FavouriteAssembly.configure(dependecies)],
                                animated: false)
    }
}
