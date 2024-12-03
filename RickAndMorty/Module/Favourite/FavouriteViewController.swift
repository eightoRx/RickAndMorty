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
            [.getFavouriteEpisode, .getChangingDataUserDefaults].forEach(perform)
        }
    }
    
    private typealias UserDataSource = UICollectionViewDiffableDataSource<Section, MainDataEpisode>
    private typealias FavouriteSnapshot = NSDiffableDataSourceSnapshot<Section, MainDataEpisode>
    private var dataSource: UserDataSource?
    var anyCancellables = Set<AnyCancellable>()

    private lazy var favouriteCollectionView = BaseCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [.setupUI, .setupNavBarText, .hideBackButtonNavBar, .makeDataSource].forEach(perform)
    }

    private func setupUI() {
        view.backgroundColor = .white
        favouriteCollectionView.dataSource = dataSource
        favouriteCollectionView.delegate = self
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
            .font: UIFont.theme.favourite.navigationLabel
        ]
    }
    
    private func makeDataSource() {
        dataSource = UserDataSource(collectionView: favouriteCollectionView,
                                    cellProvider: { (collection, indexPath, data) -> UICollectionViewCell? in
            
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: .collectionIdentifiere, for: indexPath) as? BaseCell else { return UICollectionViewCell() }
            cell.configureCellForEpisode(data: data)
            
            cell.heartButtonUpdate = {
                self.perform(.updateEpisode(episode: data))
            }
            return cell
        })
        
        viewModel?.mainDataPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] data in
                self?.perform(.updateDataSource(data: data))
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
        perform(.selectCharacterID(id: mainDataFavourite.characterID))
        detailHandler?(.moveToCharacterDetail)
    }
}

// MARK: - All actions
extension FavouriteViewController {
    
    enum AllEpisodeAction {
        case getFavouriteEpisode
        case getChangingDataUserDefaults
        case setupUI
        case setupNavBarText
        case hideBackButtonNavBar
        case makeDataSource
        case updateEpisode(episode: MainDataEpisode)
        case updateDataSource(data: [MainDataEpisode])
        case selectCharacterID(id: Int)
    }
    
    private func perform(_ action: AllEpisodeAction) {
        switch action {
        case .getFavouriteEpisode: viewModel?.getFavouriteEpisode()
        case .getChangingDataUserDefaults: viewModel?.getChangingDataUserDefaults()
        case .setupUI: setupUI()
        case .setupNavBarText: setupNavigationBarText()
        case .hideBackButtonNavBar: hideBackButtonNavBar()
        case .makeDataSource: makeDataSource()
        case .updateDataSource(let data): updateDataSource(type: data)
        case .selectCharacterID(let id): viewModel?.selectCharacterID(id: id)
        case .updateEpisode(let episode): viewModel?.updateEpisode(for: episode)
        }
    }
}
