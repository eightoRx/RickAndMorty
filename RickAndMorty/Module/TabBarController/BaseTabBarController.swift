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
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .white
        tabBar.itemPositioning = .centered
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.clear.cgColor
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowRadius = 3
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        let shadowPath = UIBezierPath(roundedRect: tabBar.bounds, cornerRadius: tabBar.layer.cornerRadius)
        tabBar.layer.shadowPath = shadowPath.cgPath
   }
}
