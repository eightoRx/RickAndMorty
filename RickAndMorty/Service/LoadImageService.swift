//
//  LoadImageService.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 10.10.2024.
//

import Foundation
import Combine
import UIKit

protocol PictureLoaderProtocol {
    func loadPicture(_ urlString: String, placeholder: Data?) -> Future<Data, NetworkError>
}


final class PictureLoaderService: PictureLoaderProtocol {
    static let shared = PictureLoaderService()
    var session: URLSession
    var subscription = Set<AnyCancellable>()
    
    init() {
        let configureation = URLSessionConfiguration.default
        configureation.urlCache = URLCache(memoryCapacity: 1024 * 1024 * 150, diskCapacity: 1024 * 1024 * 200)
        configureation.timeoutIntervalForRequest = 30
        configureation.requestCachePolicy = .returnCacheDataElseLoad
        configureation.httpMaximumConnectionsPerHost = 7
        self.session = URLSession(configuration: configureation)
        
        print("Documents directory:", FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask)[0])
    }
    
    func loadPicture(_ urlString: String, placeholder: Data? = nil) -> Future<Data, NetworkError> {
        let cacheKey = urlString
        
        if let cacheData = ImageCache.shared.getImage(forKey: cacheKey) {
            return Future<Data, NetworkError> { promise in
               promise(.success(cacheData))
            }
        }
        
        return Future<Data, NetworkError> { [weak self] promise in
            let url = URL(string: urlString)
            guard let url = url else { return }
            guard let self else {return}
            self.session.dataTaskPublisher(for: url)
                .tryMap { (data, response) in
                    guard let httpResponse = response as? HTTPURLResponse,
                          200...299 ~= httpResponse.statusCode
                    else {
                        throw NetworkError.responseError(
                            (response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    ImageCache.shared.setImage(data, forKey: cacheKey)
                    return data
                }
            .sink(receiveCompletion: { _ in},
                      receiveValue: {
                    promise(.success($0)) })
                .store(in: &subscription)
        }
    }
}

