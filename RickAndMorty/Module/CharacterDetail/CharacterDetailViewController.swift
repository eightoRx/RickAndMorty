//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit
import PhotosUI
import Combine


final class CharacterDetailViewController: UIViewController {
    
    struct CategoryCharacter: Hashable {
        let category: String
        let section: Section
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    var viewModel: CharacterDetailViewModelProtocol? {
        didSet {
            viewModel?.updateImagePicker?.delegate = self
            perform(.getCharacterData)
        }
    }
    
    private typealias UserDataSource = UITableViewDiffableDataSource<Section, CategoryCharacter>
    private typealias CharacterSnapshot = NSDiffableDataSourceSnapshot<Section, CategoryCharacter>
    private var dataSource: UserDataSource?
    
    private let headerName = ["Gender", "Status", "Species", "Origin", "Type", "Location"]
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 9
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let characterImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: ImageName.cameraIcon), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.theme.characterDetail.characterIconFont
        label.textColor = UIColor.theme.characterDetailNameColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CharacterDetailHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: .tableIdentifier)
        tableView.register(CharacterDetailCell.self,
                           forCellReuseIdentifier: .tableCellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [.setupUI, .getDataForCharacter, .configureImage, .tableViewConfiguration, .cameraButtonAction].forEach(perform)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        perform(.configureNavigationBar)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(characterImage)
        stackView.addArrangedSubview(cameraButton)
        view.addSubview(characterNameLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 108),
            
            characterNameLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            characterNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: 11),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 37),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func tableViewConfiguration() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        tableView.tableHeaderView = CharacterDetailHeaderLabel(frame: CGRect(x: 0,
                                                                             y: 0,
                                                                             width: view.frame.width,
                                                                             height: 10))
    }
    
    private func cameraButtonAction() {
        cameraButton.addTarget(self, action: #selector(addTargetForAvatarButton), for: .touchUpInside)
    }
    
    // MARK: - Configure Custom Navigation Bar
    private func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        guard let image = UIImage(named: ImageName.backButtonNavigation) else {return}
        navigationController?.setOpaqueBackgroundStyle(image: image)
        
        let imageView = UIImageView(image: UIImage(named: ImageName.navigationLogo))
        imageView.contentMode = .scaleAspectFit
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: imageView)
        
        navigationController?.navigationBar.tintColor = .black
        
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowRadius = 4
        navigationController?.navigationBar.layer.shadowOpacity = 0.4
    }
}

// MARK: - DiffableDataSource
extension CharacterDetailViewController {
    enum Section: Int, CaseIterable {
        case gender, status, species, origin, type, location
    }
    
    func getDataForCharacter() {
        
        viewModel?.iconCharacterPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] data in
                guard let data = data else {return}
                self?.characterImage.image = UIImage(data: data)
            }).store(in: &subscriptions)
        
        
        viewModel?.characterPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] data in
                guard let data = data else {return}
                self?.perform(.makeDataSource(data: data))
                self?.perform(.updateDataSource(data: data))
                self?.characterNameLabel.text = data.name
            }).store(in: &subscriptions)
    }
    
    private func makeDataSource(data: MainDataCharacter) {
        dataSource = UserDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: .tableCellIdentifier) as? CharacterDetailCell else {
                fatalError("Failed to create cell")
            }
            
            let value = self.getValue(for: item.section, from: data)
            cell.configure(data: value)
            cell.selectionStyle = .none
            return cell
        })
    }
    
    private func createCategoryCharacters(from character: MainDataCharacter) -> [CategoryCharacter] {
        return Section.allCases.map { section in
            let value = getValue(for: section, from: character)
            return CategoryCharacter(category: value, section: section)
        }
    }
    
    private func getValue(for section: Section, from character: MainDataCharacter) -> String {
        switch section {
        case .gender: return character.gender.isEmptyOrUnknown
        case .status: return character.status.isEmptyOrUnknown
        case .species: return character.specie.isEmptyOrUnknown
        case .origin: return character.origin.isEmptyOrUnknown
        case .type: return character.type.isEmptyOrUnknown
        case .location: return character.location.isEmptyOrUnknown
        }
    }
    
    
    private func updateDataSource(data: MainDataCharacter) {
        var snapshot = CharacterSnapshot()
        snapshot.appendSections(Section.allCases)
        let categorySection = createCategoryCharacters(from: data)
        
        for section in Section.allCases {
            let itemForSection = categorySection.filter { $0.section == section }
            snapshot.appendItems(itemForSection, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension CharacterDetailViewController: UITableViewDelegate {
    
    //MARK: - Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: .tableIdentifier) as?
                CharacterDetailHeaderView else { fatalError("Failed to creat header cell") }
        
        let headers = headerName[section]
        header.configure(with: headers)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
    //MARK: - Base Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        20
    }
}

//MARK: - Get image from gallery or camera
extension CharacterDetailViewController: ImagePickerDelegate {
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        
        DispatchQueue.main.async{
            self.characterImage.image = image
            self.configureImage()
        }
    }
    
    func cancellButtonDidClick(on imagePicker: ImagePicker) {
        imagePicker.dismissPicker()
        imagePicker.dismissPHPicker()
    }
    
    private func configureImage() {
        NSLayoutConstraint.activate([
            self.characterImage.widthAnchor.constraint(equalToConstant: 148),
            self.characterImage.heightAnchor.constraint(equalToConstant: 148),
        ])
        self.characterImage.contentMode = .scaleAspectFill
        self.characterImage.layer.cornerRadius = 74
        self.characterImage.layer.masksToBounds = true
        self.characterImage.layer.borderColor = UIColor.theme.borderCharacterAvatar?.cgColor
        self.characterImage.layer.borderWidth = 5
    }
}

extension CharacterDetailViewController {
    @objc private func addTargetForAvatarButton() {
        viewModel?.updateImagePicker?.showImagePicker(from: self, allowsEditing: false)
    }
}

// MARK: - All actions
extension CharacterDetailViewController {
    
    private enum AllCharacterDetailAction {
        case getCharacterData
        case setupUI
        case getDataForCharacter
        case configureImage
        case tableViewConfiguration
        case cameraButtonAction
        case configureNavigationBar
        case makeDataSource(data: MainDataCharacter)
        case updateDataSource(data: MainDataCharacter)
    }
    
    private func perform(_ action: AllCharacterDetailAction) {
        switch action {
        case .getCharacterData: viewModel?.getCharacterData()
        case .setupUI: setupUI()
        case .getDataForCharacter: getDataForCharacter()
        case .configureImage: configureImage()
        case .tableViewConfiguration: tableViewConfiguration()
        case .cameraButtonAction: cameraButtonAction()
        case .configureNavigationBar: configureNavigationBar()
        case .makeDataSource(let data): makeDataSource(data: data)
        case .updateDataSource(let data): updateDataSource(data: data)
        }
    }
}
