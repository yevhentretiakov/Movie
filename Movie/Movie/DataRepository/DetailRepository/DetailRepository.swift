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
    func fetchMovieTrailer(with id: Int, completion: @escaping MovieTrailerResult)
}

final class DefaultDetailRepository: DetailRepository {
    // MARK: - Properties
    private let networkService: NetworkManager
    
    // MARK: - Life Cycle Methods
    init(networkService: NetworkManager = DefaultNetworkManager()) {
        self.networkService = networkService
    }
    
    // MARK: - Methods
    func fetchMovieDetails(with id: Int, completion: @escaping MovieDetailsResult) {
        networkService.request(MovieDetailModel.self, from: .fetchMovieDetails(id: id)) { result in
            switch result {
            case .success(let details):
                completion(.success(details))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieTrailer(with id: Int, completion: @escaping MovieTrailerResult) {
        networkService.request(MovieVideosResponse.self, from: .fetchMovieVideos(id: id)) { result in
            switch result {
            case .success(let details):
                let trailer = details.results.first(where: { $0.type == "Trailer" })
                completion(.success(trailer))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
