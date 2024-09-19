//
//  LaunchViewController.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

final class LaunchViewController: UIViewController {
    
    enum Event {
        case launchCompleted
    }
    
    var handlerLaunch: ((LaunchViewController.Event) -> Void)?
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let loadImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "load")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.handlerLaunch?(.launchCompleted)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createAnimation(for: loadImage, duration: 3)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(logoImage)
        view.addSubview(loadImage)
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        loadImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 97),
            logoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 34),
            logoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            
            loadImage.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 146),
            loadImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 81),
            loadImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -82),
        ])
    }
    
    private func createAnimation(for image: UIImageView, duration: Double) {
        let angle = CGFloat.pi * 2
        let spin = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        spin.duration = duration
        spin.valueFunction = CAValueFunction(name: .rotateZ)
        spin.fromValue = 0
        spin.toValue = angle
        image.layer.add(spin, forKey: "spinAnimation")
        CATransaction.setDisableActions(true)
    }
}

