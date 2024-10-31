//
//  FavouriteCollectionView.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 23.10.2024.
//

import Foundation
import UIKit

final class FavouriteCollectionView: UICollectionView {
    
    
        
        init() {
            let layout = UICollectionViewFlowLayout()
            super.init(frame: .zero, collectionViewLayout: layout)
            layout.minimumLineSpacing = 52
            showsVerticalScrollIndicator = false
            backgroundColor = .clear
            layer.masksToBounds = false
            register(EpisodeCell.self, forCellWithReuseIdentifier: EpisodeCell.ident)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
