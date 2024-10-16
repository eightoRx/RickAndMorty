//
//  FavouriteViewController.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit
import Combine

final class FavouriteViewController: UIViewController {
    
    enum Event {
        case moveToCharacterDetail
    }
    
    var detailHandler: ((FavouriteViewController.Event) -> Void)?
    
    enum Section {
        case main
    }
    
    private typealias UserDataSource = UICollectionViewDiffableDataSource<Section, FavouriteModel>
    private typealias FavouriteSnapshot = NSDiffableDataSourceSnapshot<Section, FavouriteModel>
    private var dataSource: UserDataSource?
    var anyCancellables = Set<AnyCancellable>()
    
    let favouriteModel = FavouriteModel(nameSeries: Constants.nameSeries,
                                        numberSeries: Constants.numberSeries,
                                        nameCharacter: Constants.characterNameLabel,
                                        image: ImageName.characterImage,
                                        characterID: "")
    
    private lazy var favouriteCollectionView = BaseCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBarText()
        
        favouriteCollectionView.dataSource = dataSource
        favouriteCollectionView.delegate = self
        
        makeDataSource()
        updateDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(favouriteCollectionView)
        
        favouriteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favouriteCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            favouriteCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            favouriteCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -23),
            favouriteCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    private func setupNavigationBarText() {
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.theme.favourite.navigationLabel,
        ]
    }
    
    private func makeDataSource() {
        dataSource = UserDataSource(collectionView: favouriteCollectionView,
                                    cellProvider: { (collection, indexPath, data) -> UICollectionViewCell? in
            
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: .collectionIdentifiere, for: indexPath) as? BaseCollectionViewCell else {  print("Error collectionView Cell"); return UICollectionViewCell() }
            cell.configureCellForFavourite(data: data)
            return cell
        })
    }
    
    
    func updateDataSource() {
        var snapshot = FavouriteSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems([favouriteModel])
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


extension FavouriteViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1 // fix
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
        detailHandler?(.moveToCharacterDetail)
    }
}

extension FavouriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 357
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
}
