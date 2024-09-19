//
//  EpisodeViewController.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

final class EpisodeViewController: UIViewController {
    
    enum Event {
        case moveToCharacterDetail
    }
    
    var detailHandler: ((EpisodeViewController.Event) -> Void)?
    
    private let detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(detailButton)
        
        
        NSLayoutConstraint.activate([
            detailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailButton.heightAnchor.constraint(equalToConstant: 50),
            detailButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        detailButton.addTarget(self, action: #selector(showCharacterDetailScreen), for: .touchUpInside)
    }
    
   @objc func showCharacterDetailScreen() {
        detailHandler?(.moveToCharacterDetail)
    }
}
