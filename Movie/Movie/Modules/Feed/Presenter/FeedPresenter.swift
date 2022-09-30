//
//  FeedPresenter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import Foundation

// MARK: - Enums
enum MoviesSortType: String {
    case playing = "now_playing"
    case popular = "popular"
    case topRated = "top_rated"
    case upcoming = "upcoming"
}

// MARK: - Protocols
protocol FeedView: AnyObject, LoadingView {
    func reloadData()
    func showMessage(title: String, message: String)
    func scrollToTop()
}

protocol FeedPresenter {
    func viewDidLoad()
    func getItemsCount() -> Int
    func getItem(at index: Int) -> MovieUIModel
    func movieTapped(with index: Int)
    func loadMore()
    func selectSortType(_ type: MoviesSortType)
    func search(with string: String)
    func cancelSearch()
}

final class DefaultFeedPresenter: FeedPresenter {
    // MARK: - Properties
    private weak var view: FeedView?
    private let router: FeedRouter
    private let repository: FeedRepository
    private var movies = [MovieUIModel]()
    private var filteredMovies = [MovieUIModel]()
    private var genres = [GenreModel]()
    private var page = 1
    private var loadingData = false
    private var searchText = ""
    private var sortType: MoviesSortType = .popular
    
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
        return filteredMovies.count
    }
    
    func getItem(at index: Int) -> MovieUIModel {
        return filteredMovies[index]
    }
    
    func movieTapped(with index: Int) {
        router.showMovieDetails(with: filteredMovies[index].id)
    }
    
    func loadMore() {
        if !loadingData && searchText.isEmpty {
            page += 1
            fetchMovies(with: sortType, on: page)
        }
    }
    
    func selectSortType(_ type: MoviesSortType) {
        movies.removeAll()
        page = 1
        sortType = type
        fetchMovies(with: sortType, on: page) {
            self.view?.scrollToTop()
        }
    }
    
    func search(with string: String) {
        searchText = string
        if string.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter({ $0.title.lowercased().contains(searchText.lowercased()) })
        }
        view?.reloadData()
    }
    
    func cancelSearch() {
        searchText = ""
        filteredMovies = movies
        view?.reloadData()
    }
    
    // MARK: - Private Methods
    private func fetchMovies(with sortType: MoviesSortType, on page: Int, completion: EmptyBlock? = nil) {
        loadingData = true
        view?.showLoadingView()
        repository.fetchMovies(with: sortType, on: page) { [weak self] result in
            guard let self = self else { return }
            self.view?.hideLoadingView()
            self.loadingData = false
            switch result {
            case .success(let movies):
                let fetchedMovies =  movies.map({ post in
                    let genresNames = post.genreIds.compactMap { id in
                        self.genres.first(where: { $0.id == id })?.name
                    }
                    return MovieUIModel(genres: genresNames,
                                 id: post.id,
                                 voteAverage: post.voteAverage,
                                 title: post.title,
                                        backdropPath: post.backdropPath ?? "",
                                 releaseDate: post.releaseDate)
                })
                self.movies.append(contentsOf: fetchedMovies)
                self.filteredMovies = self.movies
                DispatchQueue.main.async {
                    self.view?.reloadData()
                }
            case .failure(let error):
                DefaultNetworkMonitor.shared.isReachable { [weak self] status in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if status {
                            self.view?.showMessage(title: "Error", message: error.localizedDescription)
                        } else {
                            self.view?.showMessage(title: "Error", message: NetworkError.noInternetConnection.rawValue)
                        }
                    }
                }
            }
            completion?()
        }
    }
    
    private func fetchGenres() {
        repository.fetchGenres { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let genres):
                self.genres = genres
                self.fetchMovies(with: self.sortType, on: 1)
            case .failure(let error):
                DefaultNetworkMonitor.shared.isReachable { [weak self] status in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if status {
                            self.view?.showMessage(title: "Error", message: error.localizedDescription)
                        } else {
                            self.view?.showMessage(title: "Error", message: NetworkError.noInternetConnection.rawValue)
                        }
                    }
                }
            }
        }
    }
}
