//
//  CharacterDetailHeaderLabel.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 27.09.2024.
//

import UIKit

final class CharacterDetailHeaderLabel: UIView {
    
    private let headerLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.tableViewHeaderLabel
        label.font = UIFont.getCustomFont(type: .robotoMedium, size: 20)
        label.textColor = UIColor.theme.headerLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        addSubview(headerLabel)
        
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
}
