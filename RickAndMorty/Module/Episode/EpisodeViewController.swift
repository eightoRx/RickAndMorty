//
//  EpisodeViewController.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit
import Combine

final class EpisodeViewController: UIViewController, UISearchBarDelegate {
    
    typealias UserDataSource = UICollectionViewDiffableDataSource<Section, MainDataEpisode>
    private typealias EpisodeSnapshot = NSDiffableDataSourceSnapshot<Section, MainDataEpisode>
    private var dataSource: UserDataSource?
    private var episodes: [MainDataEpisode] = []
    
    var anyCancellables = Set<AnyCancellable>()
    
    enum Event {
        case moveToCharacterDetail
    }
    var detailHandler: ((EpisodeViewController.Event) -> Void)?
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let searchTextSubject = PassthroughSubject<String?, Never>()
    
    
    private lazy var headerView = HeaderView()
    private lazy var episodeCollectionView = BaseCollectionView()
    private var filterView: UIView?
    private var backView: UIView?
    private var searchController: UISearchController!
    
    var viewModel: EpisodeViewModelProtocol? {
        didSet {
            [.checkFavouriteEpisode, .updateButtonState, .getChangingDataUserDefaults].forEach(perform)
        }
    }
    
    override func loadView() {
        super.loadView()
        [.updateSearchView].forEach(perform)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.window?.endEditing(true)
        super.touchesEnded(touches, with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        [.hideBackButtonNavBar, .setupUI, .makeDataSource, .recieveEpisodeData, .viewDidLoadSubject, .makeSearchController, .updateDataSource(episodeData: episodes), .filterButtonAction].forEach(perform)
    }
    
    private func makeSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        headerView.setSearchDelegate(self)
        searchController.obscuresBackgroundDuringPresentation = true
    }
    
    private func setupUI() {
        episodeCollectionView.dataSource = dataSource
        episodeCollectionView.delegate = self
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
    
    private func recieveEpisodeData() {
        viewModel?.mainDataPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] data in
                self?.perform(.updateDataSource(episodeData: data))
            }).store(in: &anyCancellables)
    }
}

// MARK: - Filter button
extension EpisodeViewController {
    private func showFilterButtonMenu() {
        
        let backView = UIView()
        backView.backgroundColor = .black.withAlphaComponent(0.3)
        backView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideFilterButtonMenu))
        
        backView.addGestureRecognizer(tapGesture)
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.layer.zPosition = 1
        
        view.addSubview(backView)
        self.backView = backView
        
        let filterView = EpisodePopupView()
        
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterView.layer.zPosition = 2
        view.addSubview(filterView)
        self.filterView = filterView
        
        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            filterView.topAnchor.constraint(equalTo: view.topAnchor, constant: 350),
            filterView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 150),
            filterView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        filterView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            filterView.alpha = 1
        }
        
        filterView.filterStatus = { [weak self] status in
            self?.perform(.hideFilterButtonMenu)
            self?.perform(.updateFilter(status: status))
        }
    }
    
    @objc private func hideFilterButtonMenu() {
        guard let filterView = filterView else { return }
        guard let backView = backView else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            filterView.alpha = 0
            backView.alpha = 0
        }, completion: { _ in
            filterView.removeFromSuperview()
            backView.removeFromSuperview()
            self.filterView = nil
            self.backView = nil
            self.episodeCollectionView.isUserInteractionEnabled = true
        })
    }
    
    private func filterButtonAction() {
        headerView.buttonTapped
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.perform(.showFilterButtonMenu)
            }).store(in: &anyCancellables)
    }
}

// MARK: - DataSource and snapshot
extension EpisodeViewController {
    private func makeDataSource() {
        dataSource = UserDataSource(collectionView: episodeCollectionView,
                                    cellProvider: { (collection, indexPath, data) -> UICollectionViewCell? in
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: .collectionIdentifiere, for: indexPath) as? BaseCell else { return UICollectionViewCell() }
            
            cell.configureCellForEpisode(data: data)
            cell.heartButtonUpdate = {
                self.perform(.toggleFavoriteStatus(data: data, notification: .update))
            }
            return cell
        })
    }
  
    private func updateDataSource(type: [MainDataEpisode]) {
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
        perform(.characterID(id: mainDataEpisode.characterID))
        detailHandler?(.moveToCharacterDetail)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        guard let viewModel else {return}
        
        if position > (contentHeight - 100 - height) && !viewModel.isLoading && viewModel.canLoadMorePages && !searchController.isActive {
            viewModel.fetchDataForMainScreen()
        }
    }
}

// MARK: - SearchController
extension EpisodeViewController {
   private func updateSearchView() {
        guard let viewModel = viewModel else {return}
        let input = viewModel.makeInput(viewDidLoadPublisher: viewDidLoadSubject.eraseToAnyPublisher(), searchTextPublisher: searchTextSubject.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        [output.viewDidLoadPublisher, output.searchTextPublisher].forEach {
            $0.sink{ _ in }.store(in: &anyCancellables)
        }
        output.setDataSourcePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] episode in
                OperationQueue.main.addOperation {
                    self?.updateDataSource(type: episode)
                }
            }.store(in: &anyCancellables)
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

// MARK: - All actions
extension EpisodeViewController {
    
    enum AllEpisodeAction {
        case hideBackButtonNavBar
        case updateSearchView
        case checkFavouriteEpisode
        case updateButtonState
        case getChangingDataUserDefaults
        case setupUI
        case makeDataSource
        case recieveEpisodeData
        case viewDidLoadSubject
        case makeSearchController
        case updateDataSource(episodeData: [MainDataEpisode])
        case filterButtonAction
        case hideFilterButtonMenu
        case updateFilter(status: FilterSearch)
        case showFilterButtonMenu
        case toggleFavoriteStatus(data: MainDataEpisode, notification: EpisodeViewModel.EpisodeNotifyType)
        case characterID(id: Int)
    }
    
    private func perform(_ action: AllEpisodeAction) {
        switch action {
        case .hideBackButtonNavBar: hideBackButtonNavBar()
        case .updateSearchView: updateSearchView()
        case .checkFavouriteEpisode: viewModel?.checkFavouriteEpisode()
        case .updateButtonState: viewModel?.updateButtonState()
        case .getChangingDataUserDefaults: viewModel?.getChangingDataUserDefaults()
        case .setupUI: setupUI()
        case .makeDataSource: makeDataSource()
        case .recieveEpisodeData: recieveEpisodeData()
        case .viewDidLoadSubject: viewDidLoadSubject.send()
        case .makeSearchController: makeSearchController()
        case .updateDataSource(let episodeData): updateDataSource(type: episodeData)
        case .filterButtonAction: filterButtonAction()
        case .hideFilterButtonMenu: hideFilterButtonMenu()
        case .updateFilter(let status): viewModel?.updateFilter(status)
        case .showFilterButtonMenu: showFilterButtonMenu()
        case .toggleFavoriteStatus(let episode, let notification):
            viewModel?.toggleFavoriteStatus(for: episode, notification: notification)
        case .characterID(let id): viewModel?.selectCharacterID(id: id)
        }
    }
}
