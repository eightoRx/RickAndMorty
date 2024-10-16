//
//  EpisodeCell.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 23.09.2024.
//

//import UIKit
//import Combine
//
//final class EpisodeCell: UICollectionViewCell {
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//    
//    
    
//    private let characterImage: UIImageView = {
//        let image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        return image
//    }()
//    
//    private let characterNameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.theme.episode.characterNameFont
//        label.textColor = UIColor.theme.episodeTextColor
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let middleView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private let bottomView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.theme.episodeCellBackgroundBottom
//        view.layer.cornerRadius = 16
//        return view
//    }()
//    
//    private let playIcon: UIImageView = {
//        let icon = UIImageView()
//        icon.translatesAutoresizingMaskIntoConstraints = false
//        icon.image = UIImage(named: ImageName.playImage)
//        icon.contentMode = .scaleAspectFit
//        return icon
//    }()
//    
//    private let heartIcon: UIImageView = {
//        let icon = UIImageView()
//        icon.translatesAutoresizingMaskIntoConstraints = false
//        icon.image = UIImage(named: ImageName.heartImage)
//        icon.contentMode = .scaleAspectFit
//        return icon
//    }()
//    
//    private let bottomStack: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .horizontal
//        stack.spacing = 6
//        return stack
//    }()
//    
//    private let nameSeriesLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.theme.episodeGrayTextColor
//        label.font = UIFont.theme.episode.bottomLabel
//        return label
//    }()
//    
//    private let divinerLabel: UILabel = {
//        let label = UILabel()
//        label.text = " | "
//        label.textColor = UIColor.theme.episodeGrayTextColor
//        label.font = UIFont.theme.episode.bottomLabel
//        return label
//    }()
//    
//    private let numberSeriesLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.theme.episodeGrayTextColor
//        label.font = UIFont.theme.episode.bottomLabel
//        return label
//    }()
//    
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.cornerRadius = 4
//        dropShadow(radius: 2, offsetX: 0, offsetY: 2, color: .black)
//        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//   
//    private func setupUI() {
//        backgroundColor = .white
//        contentView.addSubview(characterImage)
//        contentView.addSubview(bottomView)
//        contentView.addSubview(middleView)
//        middleView.addSubview(characterNameLabel)
//        bottomView.addSubview(playIcon)
//        bottomView.addSubview(heartIcon)
//        bottomView.addSubview(bottomStack)
//        bottomStack.addArrangedSubview(nameSeriesLabel)
//        bottomStack.addArrangedSubview(divinerLabel)
//        bottomStack.addArrangedSubview(numberSeriesLabel)
//        
//        NSLayoutConstraint.activate([
//            characterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
//            characterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            characterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            characterImage.heightAnchor.constraint(equalToConstant: 232),
//            
//            middleView.topAnchor.constraint(equalTo: characterImage.bottomAnchor),
//            middleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            middleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            middleView.heightAnchor.constraint(equalToConstant: 54),
//            
//            characterNameLabel.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 12),
//            characterNameLabel.bottomAnchor.constraint(equalTo: middleView.bottomAnchor, constant: -12),
//            characterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            
//            bottomView.topAnchor.constraint(equalTo: middleView.bottomAnchor),
//            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            
//            playIcon.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -17.4),
//            playIcon.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 25),
//            
//            heartIcon.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -14),
//            heartIcon.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -18),
//            
//            bottomStack.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -25),
//            bottomStack.leadingAnchor.constraint(equalTo: playIcon.trailingAnchor, constant: 11),
//            bottomStack.trailingAnchor.constraint(equalTo: heartIcon.leadingAnchor, constant: -10)
//        ])
//    }
    
//    func configureCell(data: MainDataEpisode) {
//        nameSeriesLabel.text = data.nameSeries.limitSimbol()
//        numberSeriesLabel.text = data.numberSeries
//        characterNameLabel.text = data.nameCharacter
//        characterImage.image = UIImage(data: data.image)
//    }

