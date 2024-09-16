//
//  AppCoordinatorProtocol.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    var baseTabBarController: BaseTabBarController {get}
    func start()
}
