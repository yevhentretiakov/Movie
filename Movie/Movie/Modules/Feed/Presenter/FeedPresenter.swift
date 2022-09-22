//
//  FeedPresenter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import Foundation

// MARK: - Protocols
protocol FeedView: AnyObject {
    func reloadData()
    func showMessage(title: String, message: String)
}

protocol FeedPresenter {
    func viewDidLoad()
    func getItemsCount() -> Int
    func getItem(at index: Int) -> MovieUIModel
    func movieTapped(with index: Int)
}

final class DefaultFeedPresenter: FeedPresenter {
    // MARK: - Properties
    private weak var view: FeedView?
    private let router: FeedRouter
    private let repository: FeedRepository
    private var movies = [MovieUIModel]()
    private var genres = [GenreModel]()
    
    // MARK: - Life Cycle Methods
    init(view: FeedView, router: FeedRouter, repository: FeedRepository) {
        self.view = view
        self.router = router
        self.repository = repository
    }
    
    // MARK: - Internal Methods
    func viewDidLoad() {
        fetchGenres()
    }
    
    func getItemsCount() -> Int {
        return movies.count
    }
    
    func getItem(at index: Int) -> MovieUIModel {
        return movies[index]
    }
    
    func movieTapped(with index: Int) {
        router.showMovieDetails(with: movies[index].id)
    }
    
    // MARK: - Private Methods
    private func fetchPopularMovies(on page: Int) {
        repository.fetchPopularMovies(on: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                if let movies = movies {
                    self.movies =  movies.map({ post in
                        // Convert genres [ids] to [string]
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
                    DispatchQueue.main.async {
                        self.view?.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view?.showMessage(title: "Network Error", message: "Please try again later...")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showMessage(title: "Network Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchGenres() {
        repository.fetchGenres { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let genres):
                if let genres = genres {
                    self.genres = genres
                    self.fetchPopularMovies(on: 1)
                } else {
                    DispatchQueue.main.async {
                        self.view?.showMessage(title: "Network Error", message: "Please try again later...")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showMessage(title: "Network Error", message: error.localizedDescription)
                }
            }
        }
    }
}
