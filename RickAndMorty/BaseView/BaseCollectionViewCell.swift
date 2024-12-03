//
//  BaseCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 14.10.2024.
//

import Foundation
import UIKit
import Combine

final class BaseCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var heartButtonUpdate: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    let characterImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
        
    }()
    
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.theme.episode.characterNameFont
        label.textColor = UIColor.theme.episodeTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.theme.episodeCellBackgroundBottom
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let playIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: ImageName.playImage)
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    private let heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: ImageName.heartButton), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 6
        return stack
    }()
    
    private let nameSeriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.episodeGrayTextColor
        label.font = UIFont.theme.episode.bottomLabel
        return label
    }()
    
    private let divinerLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.separator
        label.textColor = UIColor.theme.episodeGrayTextColor
        label.font = UIFont.theme.episode.bottomLabel
        return label
    }()
    
    private let numberSeriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.episodeGrayTextColor
        label.font = UIFont.theme.episode.bottomLabel
        return label
    }()
    
    private lazy var pan: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        return pan
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (pan.state == UIGestureRecognizer.State.changed) {
            let p: CGPoint = pan.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            self.contentView.frame = CGRect(x: p.x, y: p.y, width: width, height: height)
        }
        
        layer.cornerRadius = 4
        characterImage.clipsToBounds = true
        characterImage.layer.cornerRadius = 4
        dropShadow(radius: 2, offsetX: 0, offsetY: 2, color: .black)
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        
        backgroundColor = .white
        contentView.addSubview(characterImage)
        contentView.addSubview(bottomView)
        contentView.addSubview(middleView)
        middleView.addSubview(characterNameLabel)
        bottomView.addSubview(playIcon)
        bottomView.addSubview(heartButton)
        bottomView.addSubview(bottomStack)
        bottomStack.addArrangedSubview(nameSeriesLabel)
        bottomStack.addArrangedSubview(divinerLabel)
        bottomStack.addArrangedSubview(numberSeriesLabel)
        
        heartButton.addTarget(self, action: #selector(buttonHeartPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            characterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterImage.heightAnchor.constraint(equalToConstant: 232),
            
            middleView.topAnchor.constraint(equalTo: characterImage.bottomAnchor),
            middleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            middleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            middleView.heightAnchor.constraint(equalToConstant: 54),
            
            characterNameLabel.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 12),
            characterNameLabel.bottomAnchor.constraint(equalTo: middleView.bottomAnchor, constant: -12),
            characterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            bottomView.topAnchor.constraint(equalTo: middleView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            playIcon.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -17.4),
            playIcon.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 25),
            
            heartButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -14),
            heartButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -18),
            
            bottomStack.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -25),
            bottomStack.leadingAnchor.constraint(equalTo: playIcon.trailingAnchor, constant: 11),
        ])
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.size.height = 357
        return attributes
    }
    
    
    func configureCellForEpisode(data: MainDataEpisode) {
        nameSeriesLabel.text = data.nameSeries.limitSimbol()
        numberSeriesLabel.text = data.numberSeries
        characterNameLabel.text = data.nameCharacter
        characterImage.image = UIImage(data: data.image)
        
        let isFavourite = data.isFavourite
        let setImageForButton = isFavourite ? UIImage(named: ImageName.redHeartButton) : UIImage(named: ImageName.heartButton)
        heartButton.setCustomAnimate(setImageForButton, animated: true, reversed: true, color: .black)
        heartButton.setImage(setImageForButton, for: .normal)
    }
    
    @objc func buttonHeartPressed() {
        heartButtonUpdate?()
    }
}

extension BaseCell {
    @objc private func onPan(_ pan: UIPanGestureRecognizer) {
        guard let collectionView = self.superview as? UICollectionView,
              let dataSource = collectionView.dataSource as? EpisodeViewController.UserDataSource,
              let indexPath = collectionView.indexPath(for: self) else { return }
        
        let translation = pan.translation(in: self)
        let velocity = pan.velocity(in: self)
        
        switch pan.state {
        case .changed:
            if translation.x < 0 {
                self.transform = CGAffineTransform(translationX: translation.x, y: 0)
            }
        case .ended:
            if velocity.x < -500 {
                var snapshot = dataSource.snapshot()
                guard indexPath.item < snapshot.itemIdentifiers.count else { return }
                let item = snapshot.itemIdentifiers[indexPath.item]
                snapshot.deleteItems([item])
                dataSource.apply(snapshot, animatingDifferences: true)
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                    collectionView.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
}
