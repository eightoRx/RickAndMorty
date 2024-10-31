//
//  EpisodeViewController.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit
import Combine

final class EpisodeViewController: UIViewController, UISearchBarDelegate {
  
    private typealias UserDataSource = UICollectionViewDiffableDataSource<Section, MainDataEpisode>
    private typealias EpisodeSnapshot = NSDiffableDataSourceSnapshot<Section, MainDataEpisode>
    private var dataSource: UserDataSource?
  
    var anyCancellables = Set<AnyCancellable>()
    
    enum Event {
        case moveToCharacterDetail
    }
    
    var detailHandler: ((EpisodeViewController.Event) -> Void)?
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let searchTextSubject = PassthroughSubject<String?, Never>()
   
    var viewModel: EpisodeViewModelProtocol? {
        didSet {
            viewModel?.checkFavouriteEpisode()
            viewModel?.updateButtonState()
            viewModel?.getChangingDataUserDefaults()
         }
    }
    
    private lazy var headerView = HeaderView()
    private lazy var episodeCollectionView = EpisodeCollectionView()
    private var searchController: UISearchController!
    
    override func loadView() {
        super.loadView()
        updateSearchView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.window?.endEditing(true)
            super.touchesEnded(touches, with: event)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        self.hideBackButtonNavBar()
        setupUI()
        episodeCollectionView.dataSource = dataSource
        episodeCollectionView.delegate = self
     
        makeDataSource()
        recieveEpisodeData()
        viewDidLoadSubject.send()
        makeSearchController()
    }
    
    private func makeSearchController() {
        searchController = UISearchController(searchResultsController: nil)

        headerView.setSearchDelegate(self)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
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
 
    func recieveEpisodeData() {
        viewModel?.mainDataPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] data in
                self?.updateDataSource(type: data)
            }).store(in: &anyCancellables)
    }
}

extension EpisodeViewController {
    private func makeDataSource() {
        dataSource = UserDataSource(collectionView: episodeCollectionView,
                                    cellProvider: { (collection, indexPath, data) -> UICollectionViewCell? in
            
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: EpisodeCell.ident, for: indexPath) as? EpisodeCell else {  print("Error collectionView Cell"); return UICollectionViewCell() }
            
            cell.configureCellForEpisode(data: data)
            cell.heartButtonUpdate = {
                self.viewModel?.toggleFavoriteStatus(for: data, notification: .update)
                }
             return cell
        })
    }
    
    func updateDataSource(type: [MainDataEpisode]) {
        var snapshot = EpisodeSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(type)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension EpisodeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainDataEpisode = dataSource?.itemIdentifier(for: indexPath)
        guard let mainDataEpisode else {return}
        viewModel?.selectCharacterID(id: mainDataEpisode.characterID)
        detailHandler?(.moveToCharacterDetail)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        guard let viewModel else {return}
        
        if position > (contentHeight - 100 - height) && !viewModel.isLoading && viewModel.canLoadMorePages {
            viewModel.fetchDataForMainScreen()
        }
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

extension EpisodeViewController {
    func updateSearchView() {
        guard let viewModel = viewModel else {return}
        let input = viewModel.makeInput(viewDidLoadPublisher: viewDidLoadSubject.eraseToAnyPublisher(), searchTextPublisher: searchTextSubject.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        [output.viewDidLoadPublisher, output.searchTextPublisher].forEach {
            $0.sink{ _ in }.store(in: &anyCancellables)
        }
        output.setDataSourcePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] episode in
                self?.updateDataSource(type: episode)
            }.store(in: &anyCancellables)
    }
}

extension EpisodeViewController: UISearchResultsUpdating { // fix ???
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        searchTextSubject.send(searchText)
    }
}


extension EpisodeViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextSubject.send(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
