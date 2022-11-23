//
//  FeedRepository.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import UIKit

// MARK: - Protocols
protocol FeedRepository {
    func fetchMovies(with sortType: MoviesSortType, page: Int, completion: @escaping MovieResult)
    func fetchGenres(completion: @escaping GenresResult)
    func fetchSearch(query: String, page: Int, completion: @escaping MovieResult)
}

final class DefaultFeedRepository: FeedRepository {
    // MARK: - Properties
    private let networkManager: NetworkManager
    private var genres = [GenreModel]()
    
    // MARK: - Life Cycle Methods
    init(networkManager: NetworkManager = DefaultNetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: - Internal Methods
    func fetchGenres(completion: @escaping GenresResult) {
        networkManager.request(GenresResponse.self, from: .fetchGenres) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.genres = data.genres
                completion(.success(data.genres))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovies(with sortType: MoviesSortType, page: Int, completion: @escaping MovieResult) {
        networkManager.request(MoviesResponse.self,
                               from: .fetchMovies(sortType: sortType, page: page)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.toMovieModel(data.results).forEach { movie in
                    CoreDataManager.shared.save(.movie(movie))
                }
                completion(.success((self.toMovieModel(data.results), data.totalResults)))
            case .failure(_):
                self.fetchMoviesFromDataBase(completion: completion)
            }
        }
    }
    
    func fetchSearch(query: String, page: Int, completion: @escaping MovieResult) {
        networkManager.cancel()
        networkManager.request(MoviesResponse.self,
                               from: .fetchSearch(query: query, page: page)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                completion(.success((self.toMovieModel(data.results), data.totalResults)))
            case .failure(_):
                self.fetchSearchFromDataBase(query: query, completion: completion)
            }
        }
    }
    
    // Private Methods
    private func fetchMoviesFromDataBase(completion: @escaping MovieResult) {
        CoreDataManager.shared.fetch(Movie.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                completion(.success((self.toMovieModel(movies), movies.count)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchSearchFromDataBase(query: String, completion: @escaping MovieResult) {
        fetchMoviesFromDataBase { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let movies):
                let filteredMovies = movies.0.filter({
                    $0.title.lowercased().contains(query.lowercased())
                })
                completion(.success((filteredMovies, filteredMovies.count)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func toMovieModel(_ movies: [MovieNetworkModel]) -> [MovieUIModel] {
        return movies.map({ post in
            let genresNames = post.genreIds.compactMap { id in
                self.genres.first(where: { $0.id == id })?.name
            }
            return MovieUIModel(genres: genresNames,
                                id: post.id,
                                voteAverage: post.voteAverage,
                                title: post.title,
                                backdropPath: post.backdropPath,
                                releaseDate: post.releaseDate)
        })
    }
    
    private func toMovieModel(_ movies: [Movie]) -> [MovieUIModel] {
        return movies.compactMap({ movie in
            return MovieUIModel(genres: movie.genres!,
                                id: movie.id.intValue,
                                voteAverage: movie.voteAverage,
                                title: movie.title!,
                                backdropPath: movie.backdropPath!,
                                releaseDate: movie.releaseDate!)
        })
    }
}
