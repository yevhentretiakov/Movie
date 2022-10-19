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
    func fetchSearch(query: String, page: Int, completion: @escaping MovieResult)
}

final class DefaultFeedRepository: FeedRepository {
    // MARK: - Properties
    private let networkService: NetworkManager
    
    // MARK: - Life Cycle Methods
    init(networkService: NetworkManager = DefaultNetworkManager()) {
        self.networkService = networkService
    }
    
    // MARK: - Internal Methods
    func fetchMovies(with sortType: MoviesSortType, on page: Int, completion: @escaping MovieResult) {
        networkService.request(MoviesResponse.self, from: .fetchMovies(sortType: sortType, page: page)) { result in
            switch result {
            case .success(let data):
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchGenres(completion: @escaping GenresResult) {
        networkService.request(GenresResponse.self, from: .fetchGenres) { result in
            switch result {
            case .success(let data):
                completion(.success(data.genres))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSearch(query: String, page: Int, completion: @escaping MovieResult) {
        networkService.cancel()
        networkService.request(MoviesResponse.self, from: .fetchSearch(query: query, page: page)) { result in
            switch result {
            case .success(let data):
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
