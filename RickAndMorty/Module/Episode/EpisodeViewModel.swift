//
//  EpisodeViewModel.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//
import Combine
import Foundation
import UIKit


protocol EpisodeViewModelProtocol: AnyObject {
    typealias MainDataEpisodes = [MainDataEpisode]
    var mainDataEpisode: MainDataEpisodes {get}
    var mainDataPublished: Published<MainDataEpisodes> {get}
    var mainDataPublisher: Published<MainDataEpisodes>.Publisher {get}
    
    var isLoading: Bool {get}
    var canLoadMorePages: Bool {get}
    var isFavourite: Bool {get}
    
    func fetchDataForMainScreen()
    func selectCharacterID(id: Int)
    func toggleFavoriteStatus(for episode: MainDataEpisode, notification: EpisodeViewModel.EpisodeNotifyType)
    func checkFavouriteEpisode()
    func updateButtonState()
    func getChangingDataUserDefaults()
    
    
    func transform(input: EpisodeViewModel.Input) -> EpisodeViewModel.Output
    func makeInput(viewDidLoadPublisher: AnyPublisher<Void, Never>,
                   searchTextPublisher: AnyPublisher<String?, Never>) -> EpisodeViewModel.Input
}

class EpisodeViewModel: EpisodeViewModelProtocol {
    enum EpisodeNotifyType {
        case update
        case none
        
        func postNotification() {
            switch self {
            case .update: NotificationCenter.default.post(name: .episodeNotification, object: nil)
            case .none: break
            }
        }
    }
    // MARK: - Property
    private let service: ApiServiceProtocol
    private let pictureLoadService: PictureLoaderProtocol
    private let userDefaultsRepository: UserDefaultsRepositoryProtocol
    
    @Published private(set) var episode: [Episode] = []
    @Published private(set) var character: Character?
    @Published var mainDataEpisode: MainDataEpisodes = []
    @Published var searchText: String?
    var mainDataPublished: Published<MainDataEpisodes> { _mainDataEpisode }
    var mainDataPublisher: Published<MainDataEpisodes>.Publisher { $mainDataEpisode }
    var anyCancellables = Set<AnyCancellable>()
    
    var isLoading: Bool = false
    var currentPage = 1
    var canLoadMorePages = true
    var currentEpisode: MainDataEpisodes = []
    var isFavourite: Bool = false
    // MARK: - init
    init (_ depedencies: IDependencies) {
        self.service = depedencies.apiClient
        self.pictureLoadService = depedencies.pictureLoadService
        self.userDefaultsRepository = depedencies.userDefaultsRepository
    }
    // MARK: - Load data for cells with pagination
    func fetchDataForMainScreen() {
        guard !self.isLoading && self.canLoadMorePages else {return }
        isLoading = true
        service.fetchData(from: API.baseURL + API.episode, page: String(currentPage))
        
            .sink(receiveCompletion: { [unowned self] completion in
                self.isLoading = false
                if currentPage == 1 {
                    episode.removeAll()
                }
            }, receiveValue: { [weak self] (data: EpisodeResponse) in
                guard let self else {return}
                
                self.episode.append(contentsOf: data.results)
                for episode in data.results {
                    if let randomCharacterURL = episode.characters.randomElement() {
                        self.fetchCharacter(for: episode, characterURL: randomCharacterURL)
                    }
                }
                if data.info.pages == currentPage {
                    canLoadMorePages = false
                }
                self.currentPage += 1
            }).store(in: &anyCancellables)
    }
    // MARK: - Fetch random character for episode
    func fetchCharacter(for episode: Episode, characterURL: String) {
        service.fetchData(from: characterURL, page: nil)
            .sink(receiveCompletion: {[weak self] complition in
                if case let .failure(error) = complition {
                    self?.handleError(error)
                    print(String(describing: error))
                }
            }, receiveValue: { [weak self] (data: Character) in
                self?.handleFetchedCharacter(data, for: episode)
            }).store(in: &anyCancellables)
    }
    
    //MARK: - Fetch all data
    func handleFetchedCharacter(_ character: Character, for episode: Episode) {
        getImage(url: character.image) { [weak self] imageData in
            guard let self else { return }
            let mainDataItem = MainDataEpisode(
                nameSeries: episode.name,
                numberSeries: episode.episode,
                nameCharacter: character.name,
                image: imageData,
                characterID: character.id,
                episodeID: episode.id)
            
            self.mainDataEpisode.append(mainDataItem)
            updateButtonState()
        }
    }
    
    //MARK: - Fetch Image
    private func getImage(url: String, completion: @escaping (Data) -> Void) {
        pictureLoadService.loadPicture(url)
            .sink(receiveCompletion: { [weak self] complition in
                if case let .failure(error) = complition {
                    self?.handleError(error)
                }
            }, receiveValue: { (data: Data) in
                completion(data)
            }).store(in: &anyCancellables)
    }
    // MARK: - Error
    private func handleError(_ apiError: DataAPIError) {
        print("ERROR: \(apiError.localizedDescription)!")
    }
    // MARK: - Character ID
    func selectCharacterID(id: Int) {
        userDefaultsRepository.set(id, forKey: UserDefaultsKeys.myCharacter)
    }
    // MARK: - Check favourite state episode
    func checkFavouriteEpisode() {
        userDefaultsRepository.getFavouriteEpisode()
            .sink(receiveCompletion: { error in
                print(String(describing: error))
            }, receiveValue: { [weak self] episodes in
                guard let self else {return}
                for episode in episodes {
                    if episode.isFavourite {
                        self.currentEpisode.append(episode)
                    }
                }
            }).store(in: &anyCancellables)
    }
    
    private func isEpisodeFavourite(id: Int) -> Bool {
        currentEpisode.contains { $0.episodeID == id }
    }
    
    func updateButtonState() {
        for (index, episode) in mainDataEpisode.enumerated() {
            mainDataEpisode[index].isFavourite = isEpisodeFavourite(id: episode.episodeID)
        }
    }
    
    func toggleFavoriteStatus(for episode: MainDataEpisode, notification: EpisodeNotifyType) {
        guard let index = mainDataEpisode.firstIndex(where: { $0.episodeID == episode.episodeID }) else {return}
        mainDataEpisode[index].isFavourite.toggle()
        
        if mainDataEpisode[index].isFavourite {
            currentEpisode.append(mainDataEpisode[index])
            notification.postNotification()
        } else {
            currentEpisode.removeAll(where: { $0.episodeID == episode.episodeID })
            notification.postNotification()
        }
        userDefaultsRepository.setFavourite(currentEpisode)
        notification.postNotification()
    }
    
    func getChangingDataUserDefaults() {
        NotificationCenter.default.publisher(for: .favouriteNotification)
            .compactMap { $0.userInfo?["episode"] as? MainDataEpisode }
            .sink { [weak self] episode in
                self?.toggleFavoriteStatus(for: episode, notification: .none)
            }.store(in: &anyCancellables)
    }
}


extension EpisodeViewModel {
    
    func makeInput(viewDidLoadPublisher: AnyPublisher<Void, Never>,
                   searchTextPublisher: AnyPublisher<String?, Never>) -> Input {
        return Input(viewDidLoadPublisher: viewDidLoadPublisher, searchTextPublisher: searchTextPublisher)
    }
    
    struct Input {
        let viewDidLoadPublisher: AnyPublisher<Void, Never>
        let searchTextPublisher: AnyPublisher<String?, Never>
    }
    
    struct Output {
        let viewDidLoadPublisher: AnyPublisher<Void, Never>
        let searchTextPublisher: AnyPublisher<Void, Never>
        let setDataSourcePublisher: AnyPublisher<MainDataEpisodes, Never>
    }
    
    
    func transform(input: Input) -> Output {
        
        let viewDidLoadPublisher: AnyPublisher<Void, Never> = input
            .viewDidLoadPublisher
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.fetchDataForMainScreen()
            }).flatMap {
                return Just(()).eraseToAnyPublisher()
            }.eraseToAnyPublisher()
        
        let searchTextPublisher: AnyPublisher<Void, Never> =
        input
            .searchTextPublisher
            .handleEvents(receiveOutput: { [weak self] searchTexts in
                self?.searchText = searchTexts
            }).flatMap { _ in
                Just(()).eraseToAnyPublisher()
            }.eraseToAnyPublisher()
        
        let setDataSourcePublisher: AnyPublisher<MainDataEpisodes, Never> = Publishers
            .CombineLatest($mainDataEpisode.compactMap { $0 }, $searchText)
            .flatMap { (episode: MainDataEpisodes, searchText: String?) in
                if let searchText = searchText, !searchText.isEmpty {
                    self.canLoadMorePages = false
                    let filtered = episode.filter { $0.numberSeries.lowercased().contains(searchText.lowercased()) }
                    return Just(filtered).eraseToAnyPublisher()
                } else {
                    self.canLoadMorePages = true
                    return Just(episode).eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
        
        return .init(viewDidLoadPublisher: viewDidLoadPublisher,
                     searchTextPublisher: searchTextPublisher,
                     setDataSourcePublisher: setDataSourcePublisher)
    }
}
