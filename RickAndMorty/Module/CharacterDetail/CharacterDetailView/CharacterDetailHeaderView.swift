//
//  CharacterDetailHeaderView.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 27.09.2024.
//

import UIKit

final class CharacterDetailHeaderView: UITableViewHeaderFooterView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.getCustomFont(type: .robotoMedium, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.errorLabel
        return label
    }()
    
    func configure(with title: String) {
        label.text = title
        setupUI()
    }
  
    private func setupUI() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
        ])
    }
}
