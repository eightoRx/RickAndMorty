//
//  UIViewController + Extension.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 05.11.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func hideBackButtonNavBar() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
}
