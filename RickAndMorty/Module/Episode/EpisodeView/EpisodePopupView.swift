//
//  EpisodePopupView.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 20.11.2024.
//

import Foundation
import UIKit
import Combine

class EpisodePopupView: UIView {
    
    var filterStatus: ((FilterSearch) -> Void)?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var numberSeriesButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.numberSeriesFilterButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.theme.episode.filterNameButton
        button.addTarget(self, action: #selector(numberSeriesAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var characterNameFilterButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.characterFilterButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.theme.episode.filterNameButton
        button.addTarget(self, action: #selector(characterAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var seriesNameFilterButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.nameSeriesFilterButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.theme.episode.filterNameButton
        button.addTarget(self, action: #selector(nameSeriesAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        addSubview(stackView)
        
        stackView.addArrangedSubview(numberSeriesButton)
        stackView.addArrangedSubview(characterNameFilterButton)
        stackView.addArrangedSubview(seriesNameFilterButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    @objc func numberSeriesAction() {
        filterStatus?(.number)
    }
    
    @objc func characterAction() {
        filterStatus?(.character)
    }
    
    @objc func nameSeriesAction() {
        filterStatus?(.named)
    }
}
