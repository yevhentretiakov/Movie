//
//  FeedRepository.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import UIKit
import Alamofire

typealias MovieModelResult = (Result<[MovieNetworkModel]?, AFError>) -> Void
typealias GenreModelResult = (Result<[GenreModel]?, AFError>) -> Void

// MARK: - Protocols
protocol FeedRepository {
    func fetchPopularMovies(on page: Int, completion: @escaping MovieModelResult)
    func fetchGenres(completion: @escaping GenreModelResult)
}

final class DefaultFeedRepository: FeedRepository {
    // MARK: - Properties
    private let networkService: NetworkService
    
    // MARK: - Life Cycle Methods
    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Internal Methods
    func fetchPopularMovies(on page: Int, completion: @escaping MovieModelResult) {
        networkService.request(MoviesResponse.self, from: .fetchPopularMovies(page: page)) { response in
            if let error = response.error {
                completion(.failure(error))
            } else {
                completion(.success(response.value?.results))
            }
        }
    }
    
    func fetchGenres(completion: @escaping GenreModelResult) {
        networkService.request(GenresResponse.self, from: .fetchGenres) { response in
            if let error = response.error {
                completion(.failure(error))
            } else {
                completion(.success(response.value?.genres))
            }
        }
    }
}
