//
//  HeaderView.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 25.09.2024.
//
import UIKit

final class HeaderView: UIView, UISearchBarDelegate {
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: ImageName.logoImage)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.theme.episodeFilterColor
        return button
    }()
    
    private let searchField: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.layer.borderWidth = 1
        search.layer.borderColor = UIColor.gray.cgColor
        search.searchTextField.backgroundColor = .clear
        return search
    }()
    
    let attributedTextForFilterButton = NSAttributedString(string: "advanced filters".uppercased(), attributes: [
        .font: UIFont.getCustomFont(type: .robotoMedium, size: 14),
        .kern: 2
    ])
    
    let attributedTextForSearchBar = NSAttributedString(string: "Name or episode (ex.S01E01)...", attributes: [
        .font: UIFont.getCustomFont(type: .robotoRegular, size: 16),
    ])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureFilterButton(filterButton)
        configureSearchBar(searchField)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.zPosition = 1
        
        addSubview(logoImage)
        addSubview(searchField)
        addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: topAnchor, constant: 57),
            logoImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            searchField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 59),
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            searchField.heightAnchor.constraint(equalToConstant: 56),
            
            filterButton.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 12),
            filterButton.leadingAnchor.constraint(equalTo: searchField.leadingAnchor),
            filterButton.trailingAnchor.constraint(equalTo: searchField.trailingAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    private func configureFilterButton(_ button: UIButton) {
        button.layer.cornerRadius = 4
        button.dropShadow(radius: 1.5, offsetX: 0, offsetY: 1.5, color: .black)
        button.setAttributedTitle(attributedTextForFilterButton, for: .normal)
        button.setTitleColor(UIColor.theme.episodeFilterTitleColor, for: .normal)
        button.addLeftImage(image: UIImage(named: "filter")!, offset: 21.69)
        button.setAttributedTitle(attributedTextForFilterButton, for: .normal)
        button.makeSystem()
    }
    
    private func configureSearchBar(_ searchBar: UISearchBar) {
        searchBar.layer.cornerRadius = 8
        searchBar.searchTextField.attributedPlaceholder = attributedTextForSearchBar
    }
     func setSearchDelegate(_ delegate: UISearchBarDelegate) {
        searchField.delegate = delegate
    }
}
