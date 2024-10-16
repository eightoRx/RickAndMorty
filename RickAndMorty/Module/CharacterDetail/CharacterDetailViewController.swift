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
    
    private var subscriptions = Set<AnyCancellable>()
    
    var viewModel: CharacterDetailViewModelProtocol? {
        didSet {
            viewModel?.updateImagePicker?.delegate = self
            viewModel?.getCharacterData()
        }
    }
    
    struct CategoryCharacter: Hashable {
        let category: String
        let section: Section
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
                           forHeaderFooterViewReuseIdentifier: CharacterDetailHeaderView.identifier)
        tableView.register(CharacterDetailCell.self,
                           forCellReuseIdentifier: CharacterDetailCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.dataSource = dataSource
        tableView.delegate = self
        getDataForCharacter()
        configureImage()
        
        viewModel?.getCharacterData() // fix
  
        
        cameraButton.addTarget(self, action: #selector(addTargetForAvatarButton), for: .touchUpInside)
        
        tableView.tableHeaderView = CharacterDetailHeaderLabel(frame: CGRect(x: 0,
                                                                             y: 0,
                                                                             width: view.frame.width,
                                                                             height: 10))
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    @objc func addTargetForAvatarButton() {
        viewModel?.updateImagePicker?.showImagePicker(from: self, allowsEditing: false) // ?
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
                    self?.makeDataSource(data: data)
                    self?.updateDataSource(data: data)
                    self?.characterNameLabel.text = data.name
            }).store(in: &subscriptions)
   }
    
    private func makeDataSource(data: MainDataCharacter) {
        dataSource = UserDataSource(tableView: tableView, cellProvider: { tableView, indexPath, character in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterDetailCell.identifier) as? CharacterDetailCell else {
                fatalError("Failed to create cell")
            }
            let section = Section(rawValue: indexPath.section)

            let type = data.type.isEmpty ? "Unknown" : data.type
            let gender = data.gender == "unknown" ? "Unknown" : data.gender
            let status = data.status == "unknown" ? "Unknown" : data.status
            let specie = data.specie == "unknown" ? "Unknown" : data.specie
            let location = data.location == "unknown" ? "Unknown" : data.location
            let origin = data.origin == "unknown" ? "Unknown" : data.origin

            switch section {
            case .gender: cell.configure(data: gender)
            case .status: cell.configure(data: status)
            case .species: cell.configure(data: specie)
            case .origin: cell.configure(data: origin)
            case .type: cell.configure(data: type)
            case .location: cell.configure(data: location)
            case nil: break
            }
       
            cell.selectionStyle = .none
            return cell
        })
    }
    
    private func updateDataSource(data: MainDataCharacter) {
        var snapshot = CharacterSnapshot()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems([CategoryCharacter(category: data.gender, section: .gender)], toSection: .gender)
        snapshot.appendItems([CategoryCharacter(category: data.status, section: .status)], toSection: .status)
        snapshot.appendItems([CategoryCharacter(category: data.specie, section: .species)], toSection: .species)
        snapshot.appendItems([CategoryCharacter(category: data.origin, section: .origin)], toSection: .origin)
        snapshot.appendItems([CategoryCharacter(category: data.type, section: .type)], toSection: .type)
        snapshot.appendItems([CategoryCharacter(category: data.location, section: .location)], toSection: .location)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension CharacterDetailViewController: UITableViewDelegate {
    
    //MARK: - Header
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CharacterDetailHeaderView.identifier) as?
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
