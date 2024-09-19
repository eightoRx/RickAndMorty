//
//  BaseTabBarAssembly.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 19.09.2024.
//

import UIKit

final class BaseTabBarAssembly {
    static func configure(_ dependencies: IDependencies) -> UITabBarController {
        return dependencies.moduleContainer.getBaseTabBarController()
    }
}
