//
//  SceneDelegate.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var dependencies: IDependencies = Dependencies()
    private var coordinator: AppCoordinatorProtocol?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        configureScene(windowScene)
    }
    
    private func configureScene(_ windowScene: UIWindowScene) {
        let rootCotroller = BaseTabBarController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootCotroller
        window?.makeKeyAndVisible()
        coordinator = AppCoordinator(rootCotroller, dependencies: dependencies)
        coordinator?.start()
    }
}

