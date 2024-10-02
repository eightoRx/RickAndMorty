//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 16.09.2024.
//

import UIKit
import PhotosUI

final class CharacterDetailViewController: UIViewController {
    
    let imagePicker = ImagePicker()
    
    let status: [NameStatus] = [
        NameStatus(nameStatus: "Gender", statusCharacter: ["Male"]),
        NameStatus(nameStatus: "Status", statusCharacter: ["Alive"]),
        NameStatus(nameStatus: "Specie", statusCharacter: ["Human"]),
        NameStatus(nameStatus: "Origin", statusCharacter: ["Earth (C-137)"]),
        NameStatus(nameStatus: "Type", statusCharacter: ["Unknown"]),
        NameStatus(nameStatus: "Location", statusCharacter: ["Earth (Replacement Dimension)"])
    ]
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 9
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let characterImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ImageName.characterIcon)
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
        label.text = Constants.characterNameLabel
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
        tableView.dataSource = self
        tableView.delegate = self
        imagePicker.delegate = self
        
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
        imagePicker.showImagePicker(from: self, allowsEditing: false)
    }
}

extension CharacterDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Header
    
    func numberOfSections(in tableView: UITableView) -> Int {
        status.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CharacterDetailHeaderView.identifier) as?
                CharacterDetailHeaderView else { fatalError("Failed to creat header cell") }
        let headerTitle = status[section].nameStatus
        header.configure(with: headerTitle)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
    //MARK: - Base Cell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        status[section].statusCharacter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterDetailCell.identifier,
                                                       for: indexPath) as? CharacterDetailCell else {
            fatalError("Failed to create cell")
        }
        
        let title = status[indexPath.section].statusCharacter[indexPath.row]
        cell.configure(with: title)
        cell.selectionStyle = .none
        
        return cell
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
            
            NSLayoutConstraint.activate([
                self.characterImage.widthAnchor.constraint(equalToConstant: 147),
                self.characterImage.heightAnchor.constraint(equalToConstant: 148),
            ])
            self.characterImage.contentMode = .scaleAspectFill
            self.characterImage.layer.cornerRadius = 74
            self.characterImage.layer.masksToBounds = true
            self.characterImage.layer.borderColor = UIColor.theme.borderCharacterAvatar?.cgColor
            self.characterImage.layer.borderWidth = 5
        }
    }
    
    func cancellButtonDidClick(on imagePicker: ImagePicker) {
        imagePicker.dismissPicker()
        imagePicker.dismissPHPicker()
    }
}
