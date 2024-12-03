//
//  CharacterDetailCell.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 23.09.2024.
//

import UIKit

final class CharacterDetailCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.characterDetailSeparatorCell
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.getCustomFont(type: .robotoLight, size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.theme.titleCell
        return label
    }()
    
    func configure(data: String) {
        label.text = data
    }
    
    private func setupUI() {
        addSubview(label)
        addSubview(separator)
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            
            separator.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
