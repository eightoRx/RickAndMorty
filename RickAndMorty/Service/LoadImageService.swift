//
//  LoadImageService.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 10.10.2024.
//

import Foundation
import Combine

protocol PictureLoaderProtocol {
    func loadPicture(_ urlString: String) -> Future<Data, DataAPIError>
}


final class PictureLoaderService: PictureLoaderProtocol {
    static let shared = PictureLoaderService()
    var session: URLSession
    var subscription = Set<AnyCancellable>()
    
    init() {
        let configureation = URLSessionConfiguration.default
        configureation.urlCache = URLCache(memoryCapacity: 1024 * 1024 * 50, diskCapacity: 1024 * 1024 * 125)
        configureation.requestCachePolicy = .returnCacheDataElseLoad
        configureation.httpMaximumConnectionsPerHost = 7
        self.session = URLSession(configuration: configureation)
        
        print("Documents directory:", FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask)[0])
    }
    func loadPicture(_ urlString: String) -> Future<Data, DataAPIError> {
        return Future<Data, DataAPIError> { [weak self] promise in
            let url = URL(string: urlString)
            guard let url = url else { return }
            guard let self else {return}
            self.session.dataTaskPublisher(for: url)
                .tryMap { (data, response) in
                    guard let httpResponse = response as? HTTPURLResponse,
                          200...299 ~= httpResponse.statusCode
                    else {
                        throw DataAPIError.responseError(
                            (response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                }
                .sink(receiveCompletion: { _ in},
                      receiveValue: {
                    promise(.success($0)) })
                .store(in: &subscription)
        }
    }
}

