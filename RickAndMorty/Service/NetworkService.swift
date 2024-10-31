//
//  NetworkClient.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 07.10.2024.
//

import Foundation
import Combine

enum DataAPIError: Error, LocalizedError { // fix
    case urlError(URLError)
    case responseError(Int)
    case decodingError(DecodingError)
    case anyError
    
    var localizedDescription: String {
        switch self {
        case .urlError(let error):
            return error.localizedDescription
        case .decodingError(let error):
            return error.localizedDescription
        case .responseError(let error):
            return "Bad response code: \(error)"
        case .anyError:
            return "Unknown error has ocurred"
        }
    }
}


protocol ApiServiceProtocol {
    func fetchData<T: Codable>(from endpoint: String, page: String?) -> Future<T, DataAPIError>
}

final class CombineNetworkService: ApiServiceProtocol {
    
    static let shared = CombineNetworkService()
    private var urlSession = URLSession.shared
    private var subscription = Set<AnyCancellable>()
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    init() {
        let configureation = URLSessionConfiguration.default
        configureation.timeoutIntervalForRequest = 30
        self.urlSession = URLSession(configuration: configureation)
    }
    
    func fetchData<T>(from url: String, page: String? = nil) -> Future<T, DataAPIError> where T : Decodable, T : Encodable {
        return Future<T, DataAPIError> { [unowned self] promise in
         
            guard let url = URL(string: url + (page ?? "")) else { return } // fix
            self.urlSession.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse,
                          200...299 ~= httpResponse.statusCode
                    else {
                        throw DataAPIError.responseError(
                            (response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
                }
                .decode(type: T.self, decoder: self.jsonDecoder)
                .receive(on: RunLoop.main)
                .sink { complition in
                    if case let .failure(error) = complition {
                        switch error {
                        case let urlError as URLError:
                            promise(.failure(.urlError(urlError)))
                        case let decodingError as DecodingError:
                            promise(.failure(.decodingError(decodingError)))
                        case let apiError as DataAPIError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(.anyError))
                        }
                    }
                }
        receiveValue: {
            promise(.success($0))
        }
        .store(in: &self.subscription)
        }
    }
}
