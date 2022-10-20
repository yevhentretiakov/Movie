//
//  FeedPresenter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import Foundation
import CoreData

// MARK: - Enums
enum MoviesSortType {
    case playing
    case popular
    case topRated
    case upcoming
    
    var path: String {
        switch self {
        case .playing:
            return "now_playing"
        case .popular:
            return "popular"
        case .topRated:
            return "top_rated"
        case .upcoming:
            return "upcoming"
        }
    }
}

// MARK: - Protocols
protocol FeedView: AnyObject, Loadable {
    func reloadData()
    func showMessage(title: String, message: String)
    func scrollToTop()
}

protocol FeedPresenter {
    func viewDidLoad()
    func getItemsCount() -> Int
    func getItem(at index: Int) -> MovieUIModel
    func showMovieDetails(with index: Int)
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
    private var moviesStorage = [MoviesSortType: [MovieUIModel]]()
    private var pageCounter = [MoviesSortType: Int]()
    private var searchPage = 1
    private var movies = [MovieUIModel]()
    private var genres = [GenreModel]()
    private var loadingData = false
    private var searchText = "" {
        willSet {
            if newValue != searchText {
                movies.removeAll()
                searchPage = 1
            }
        }
    }
    private var sortType: MoviesSortType = .popular
    private var searchWorkItem: DispatchWorkItem? = nil
    private var fetchedFromDataBase = false
    
    // MARK: - Life Cycle Methods
    init(view: FeedView,
         router: FeedRouter,
         repository: FeedRepository) {
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
    
    func showMovieDetails(with index: Int) {
        router.showMovieDetails(with: movies[index].id)
    }
    
    func loadMore() {
        if fetchedFromDataBase == false {
            if !loadingData && searchText.isEmpty {
                pageCounter[sortType, default: 1] += 1
                fetchMovies(with: sortType, on: getPage())
            } else if !loadingData && !searchText.isEmpty {
                searchPage += 1
                fetchSearch(query: searchText, page: getPage())
            }
        }
    }
    
    func selectSortType(_ type: MoviesSortType) {
        sortType = type
        DispatchQueue.main.async {
            self.view?.scrollToTop()
        }
        if moviesStorage[type] == nil {
            fetchMovies(with: sortType, on: getPage())
        } else {
            showLoadedMovies()
        }
    }
    
    func search(with string: String) {
        searchWorkItem?.cancel()
        searchText = string
        if searchText.isEmpty {
            cancelSearch()
        } else {
            searchWorkItem = DispatchWorkItem {
                self.startSearch()
            }
            if let searchWorkItem = searchWorkItem {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: searchWorkItem)
            }
        }
    }
    
    func cancelSearch() {
        searchText = ""
        showLoadedMovies()
    }
    
    // MARK: - Private Methods
    private func showLoadedMovies() {
        if fetchedFromDataBase {
            fetchMoviesFromDataBase()
        } else {
            movies = moviesStorage[sortType, default: []]
            DispatchQueue.main.async {
                self.view?.scrollToTop()
                self.view?.reloadData()
            }
        }
    }
    
    private func startSearch() {
        if searchText.isEmpty {
            showLoadedMovies()
        } else {
            fetchSearch(query: searchText, page: getPage())
        }
    }
    
    private func fetchGenres() {
        repository.fetchGenres { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let genres):
                self.genres = genres
                self.fetchMovies(with: self.sortType, on: self.getPage())
            case .failure(let error):
                self.showError(error)
                self.fetchMoviesFromDataBase()
            }
        }
    }
    
    private func fetchMovies(with sortType: MoviesSortType,
                             on page: Int,
                             completion: EmptyBlock? = nil) {
        startDataLoading()
        repository.fetchMovies(with: sortType, on: page) { [weak self] result in
            guard let self = self else { return }
            self.finishDataLoading()
            switch result {
            case .success(let movies):
                self.fetchedFromDataBase = false
                self.updateMovies(with: movies)
            case .failure(let error):
                self.showError(error)
                self.fetchMoviesFromDataBase()
            }
            completion?()
        }
    }
    
    private func fetchSearch(query: String, page: Int) {
        startDataLoading()
        repository.fetchSearch(query: query, page: page) { [weak self] result in
            guard let self = self else { return }
            self.finishDataLoading()
            switch result {
            case .success(let movies):
                self.searchMovies(with: movies)
            case .failure(let error):
                if let networkError = error as? NetworkError,
                    networkError == .noInternetConnection {
                    self.searchInStoredMovies()
                } else {
                    self.showError(error)
                }
            }
        }
    }
    
    private func searchMovies(with data: [MovieNetworkModel]) {
        movies += transformToModel(data)
        DispatchQueue.main.async {
            self.view?.reloadData()
        }
    }
    
    private func updateMovies(with data: [MovieNetworkModel]) {
        moviesStorage[sortType, default: []] += transformToModel(data)
        // Save to Core Data
        transformToModel(data).forEach { movie in
            DefaultCoreDataManager.shared.save(.movie(movie))
        }
        
        if let array = moviesStorage[sortType] {
            movies = array
            DispatchQueue.main.async {
                self.view?.reloadData()
            }
        }
    }
    
    private func searchInStoredMovies() {
        fetchMoviesFromDataBase()
        let localFilteredMovies = movies.filter({
            $0.title.lowercased().contains(self.searchText.lowercased())
        })
        if movies != localFilteredMovies {
            movies = localFilteredMovies
            DispatchQueue.main.async {
                self.view?.reloadData()
            }
            showError(NetworkError.noInternetConnection)
        }
    }
    
    private func startDataLoading() {
        loadingData = true
        view?.showLoadingView()
    }
    
    private func finishDataLoading() {
        view?.hideLoadingView()
        loadingData = false
    }
    
    private func transformToModel(_ movies: [MovieNetworkModel]) -> [MovieUIModel] {
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
    
    private func transformToModel(_ movies: [Movie]) -> [MovieUIModel] {
        return movies.compactMap({ movie in
            return MovieUIModel(genres: movie.genres!,
                                id: movie.id.intValue,
                                voteAverage: movie.voteAverage,
                                title: movie.title!,
                                backdropPath: movie.backdropPath!,
                                releaseDate: movie.releaseDate!)
        })
    }
    
    private func showError(_ error: Error) {
        if let networkError = error as? NetworkError {
            self.view?.showMessage(title: "Error",
                                   message: networkError.message)
        } else {
            self.view?.showMessage(title: "Error",
                                   message: error.localizedDescription)
        }
    }
    
    private func fetchMoviesFromDataBase() {
        fetchedFromDataBase = true
        DefaultCoreDataManager.shared.fetch(Movie.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.movies = self.transformToModel(movies)
                DispatchQueue.main.async {
                    self.view?.reloadData()
                }
            case .failure(let error):
                self.showError(error)
            }
        }
    }
    
    private func getPage() -> Int {
        return pageCounter[sortType, default: 1]
    }
}
