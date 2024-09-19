//
//  BaseTabBarController.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 17.09.2024.
//

import UIKit

final class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
  
    private func configureUI() {
        self.tabBar.isTranslucent = true
        self.tabBar.backgroundColor = .white
        self.tabBar.itemPositioning = .centered
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = .init(gray: 0.5, alpha: 0.5)
    }
}
