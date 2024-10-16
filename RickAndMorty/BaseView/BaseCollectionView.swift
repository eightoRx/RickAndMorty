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
            let layout = UICollectionViewFlowLayout()
            super.init(frame: .zero, collectionViewLayout: layout)
            layout.minimumLineSpacing = 52
            showsVerticalScrollIndicator = false
            backgroundColor = .clear
            layer.masksToBounds = false
            register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: .collectionIdentifiere)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
