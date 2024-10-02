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
    
    let headerView = HeaderView()
    
    lazy var episodeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(EpisodeCell.self, forCellWithReuseIdentifier: .collectionIdentifiere)
        layout.minimumLineSpacing = 52
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.layer.masksToBounds = false
        return collection
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        view.backgroundColor = .white
        setupUI()
        episodeCollectionView.dataSource = self
        episodeCollectionView.delegate = self
    }
    
    private func setupUI() {
        view.addSubview(headerView)
        view.addSubview(episodeCollectionView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 360),
            
            episodeCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            episodeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            episodeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -23),
            episodeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}


extension EpisodeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .collectionIdentifiere, for: indexPath) as? EpisodeCell else {  print("Error collectionView Cell"); return UICollectionViewCell() }
        
        return cell
    }
}


extension EpisodeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        detailHandler?(.moveToCharacterDetail)
    }
}


extension EpisodeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 357
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
}
