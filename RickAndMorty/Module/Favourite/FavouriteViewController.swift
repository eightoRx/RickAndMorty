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
    
    var viewModel: FavouriteViewModelProtocol? {
        didSet {
            viewModel?.getFavouriteEpisode()
            viewModel?.getChangingDataUserDefaults()
        }
    }
    
    private typealias UserDataSource = UICollectionViewDiffableDataSource<Section, MainDataEpisode>
    private typealias FavouriteSnapshot = NSDiffableDataSourceSnapshot<Section, MainDataEpisode>
    private var dataSource: UserDataSource?
    var anyCancellables = Set<AnyCancellable>()

    private lazy var favouriteCollectionView = BaseCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBarText()
        self.hideBackButtonNavBar()
        favouriteCollectionView.dataSource = dataSource
        favouriteCollectionView.delegate = self
        
        makeDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: .collectionIdentifiere, for: indexPath) as? BaseCell else { return UICollectionViewCell() }
            cell.configureCellForEpisode(data: data)
            
            cell.heartButtonUpdate = {
                self.viewModel?.updateEpisode(for: data)
            }
            return cell
        })
        
        viewModel?.mainDataPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { data in
                self.updateDataSource(type: data)
            }).store(in: &anyCancellables)
    }
    
    
    func updateDataSource(type: [MainDataEpisode]) {
        var snapshot = FavouriteSnapshot()
        snapshot.appendSections([.favourite])
        snapshot.appendItems(type)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


extension FavouriteViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainDataFavourite = dataSource?.itemIdentifier(for: indexPath)
        guard let mainDataFavourite else {return}
        viewModel?.selectCharacterID(id: mainDataFavourite.characterID)
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
