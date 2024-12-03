//
//  ImageCache.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 17.11.2024.
//

import Foundation
import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    private let cache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func getImage(forKey key: String) -> Data? {
        return cache.object(forKey: key as NSString) as? Data
    }
    
    func setImage(_ image: Data, forKey key: String) {
        cache.setObject(image as NSData, forKey: key as NSString)
    }
}
