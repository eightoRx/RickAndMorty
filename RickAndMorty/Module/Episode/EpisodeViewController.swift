//
//  EpisodeViewController.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit
import Combine

final class EpisodeViewController: UIViewController {
    
    
    
    enum Section {
        case main
    }
    
    private typealias UserDataSource = UICollectionViewDiffableDataSource<Section, MainDataEpisode>
    private typealias EpisodeSnapshot = NSDiffableDataSourceSnapshot<Section, MainDataEpisode>
    private var dataSource: UserDataSource?
  
    var anyCancellables = Set<AnyCancellable>()
    
    enum Event {
        case moveToCharacterDetail
    }
    
    var detailHandler: ((EpisodeViewController.Event) -> Void)?
    
    var viewModel: EpisodeViewModelProtocol? {
        didSet {
            viewModel?.fetchDataForMainScreen()
        }
    }
    
    private lazy var headerView = HeaderView()
    private lazy var episodeCollectionView = BaseCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hideBackButtonNavBar()
        setupUI()
        episodeCollectionView.dataSource = dataSource
        episodeCollectionView.delegate = self
        makeDataSource()
        makeDataForSnapshor()
    }
    
    private func setupUI() {
        view.addSubview(headerView)
        view.addSubview(episodeCollectionView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        episodeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func makeDataForSnapshor() {
       viewModel?.mainDataPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { data in
                self.updateDataSource(type: data)
            }).store(in: &anyCancellables)
        }
   
    func updateDataSource(type: [MainDataEpisode]) {
        var snapshot = EpisodeSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(type)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func hideBackButtonNavBar() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
}

extension EpisodeViewController {
    private func makeDataSource() {
        dataSource = UserDataSource(collectionView: episodeCollectionView,
                                    cellProvider: { (collection, indexPath, data) -> UICollectionViewCell? in
            
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: .collectionIdentifiere, for: indexPath) as? BaseCollectionViewCell else {  print("Error collectionView Cell"); return UICollectionViewCell() }
            cell.configureCellForEpisode(data: data)

            cell.heartButtonUpdate = { self.viewModel?.updateEpisode(for: data)
                }
            
          
            return cell
        })
    }
}

extension EpisodeViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20 // fix
    }
}

extension EpisodeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainDataEpisode = dataSource?.itemIdentifier(for: indexPath)
        guard let mainDataEpisode else {return}
        viewModel?.selectCharacterID(id: mainDataEpisode.characterID)
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
