//
//  UINavigationController+Extension.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 01.10.2024.
//

import UIKit

extension UINavigationController {
    func setOpaqueBackgroundStyle(image: UIImage) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        navigationBar.scrollEdgeAppearance = appearance
    }
    
//    func hideBackButtonNavBar() {
//        let backButton = UIBarButtonItem()
//        backButton.title = ""
//        navigationItem.backBarButtonItem = backButton
//    }
}

extension UIViewController {
    func hideBackButtonNavBar() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
}
