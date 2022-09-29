//
//  DetailRepository.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 21.09.2022.
//

import Foundation

// MARK: - Protocols
protocol DetailRepository {
    func fetchMovieDetails(with id: Int, completion: @escaping MovieDetailsResult)
}

final class DefaultDetailRepository: DetailRepository {
    // MARK: - Properties
    private let networkService: NetworkService
    
    // MARK: - Life Cycle Methods
    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Methods
    func fetchMovieDetails(with id: Int, completion: @escaping MovieDetailsResult) {
        networkService.request(MovieDetailModel.self, from: .fetchMovieDetails(id: id)) { response in
            if let error = response.error {
                completion(.failure(error))
            } else {
                completion(.success(response.value))
            }
        }
    }
}
