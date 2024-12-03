//
//  BaseCollectionView.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 14.10.2024.
//

import Foundation
import UIKit

final class BaseCollectionView: UICollectionView {
    
    init() {
        
        let compositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .absolute(357))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(357))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 52
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0)
            return section
        }
        super.init(frame: .zero, collectionViewLayout: compositionalLayout)
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        layer.masksToBounds = false
        register(BaseCell.self, forCellWithReuseIdentifier: .collectionIdentifiere)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}
