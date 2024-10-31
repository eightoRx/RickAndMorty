//
//  BaseCollectionBETA.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 23.10.2024.
//
//
//import Foundation
//import UIKit
//import Combine
//
//final class BaseCollectionViewBETA: UICollectionView {
//    
//    private typealias DataSource = UICollectionViewDiffableDataSource<Section, MainDataEpisode>
//    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MainDataEpisode>
//    private var dataSourceBETA: DataSource?
//    
//        
//        init() {
//            let layout = UICollectionViewFlowLayout()
//            super.init(frame: .zero, collectionViewLayout: layout)
//            layout.minimumLineSpacing = 52
//            showsVerticalScrollIndicator = false
//            backgroundColor = .clear
//            layer.masksToBounds = false
//            register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: .collectionIdentifiere)
//        }
//        
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//    
//  
//    func makeDataSource() {
//            dataSourceBETA = DataSource(collectionView: self,
//                                        cellProvider: { (collection, indexPath, data) -> UICollectionViewCell? in
//                
//                guard let cell = collection.dequeueReusableCell(withReuseIdentifier: .collectionIdentifiere, for: indexPath) as? BaseCollectionViewCell else {  print("Error collectionView Cell"); return UICollectionViewCell() }
//                cell.configureCellForEpisode(data: data)
//
//                 return cell
//            })
//        }
//        
//        func updateDataSource(type: [MainDataEpisode]) {
//            var snapshot = Snapshot()
//            snapshot.appendSections([.main, .favourite])
//            snapshot.appendItems(type, toSection: .main)
//            snapshot.appendItems(type, toSection: .favourite)
//            dataSourceBETA?.apply(snapshot, animatingDifferences: false)
//        }
//    }
//    
