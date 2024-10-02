//
//  FavouriteViewController.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit

final class FavouriteViewController: UIViewController {
    
    enum Event {
        case moveToCharacterDetail
    }
    
    var detailHandler: ((FavouriteViewController.Event) -> Void)?
    
    
    
    private let detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = false
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.red.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        button.layer.shadowRadius = 5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addShadowPath()
    }
    
    func setupUI() {
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
    
    func addShadowPath() {
        let shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                   y: 5,
                                                   width: Int(detailButton.bounds.width),
                                                   height: Int(detailButton.bounds.height) - 5))
        
        detailButton.layer.shadowPath = shadowPath.cgPath
    }
}
