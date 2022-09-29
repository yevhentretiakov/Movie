//
//  FeedRepository.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import UIKit

// MARK: - Protocols
protocol FeedRepository {
    func fetchMovies(with sortType: MoviesSortType, on page: Int, completion: @escaping MovieResult)
    func fetchGenres(completion: @escaping GenresResult)
}

final class DefaultFeedRepository: FeedRepository {
    // MARK: - Properties
    private let networkService: NetworkService
    
    // MARK: - Life Cycle Methods
    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Internal Methods
    func fetchMovies(with sortType: MoviesSortType, on page: Int, completion: @escaping MovieResult) {
        networkService.request(MoviesResponse.self, from: .fetchMovies(sortType: sortType, page: page)) { response in
            if let error = response.error {
                completion(.failure(error))
            } else {
                completion(.success(response.value?.results))
            }
        }
    }
    
    func fetchGenres(completion: @escaping GenresResult) {
        networkService.request(GenresResponse.self, from: .fetchGenres) { response in
            if let error = response.error {
                completion(.failure(error))
            } else {
                completion(.success(response.value?.genres))
            }
        }
    }
}
