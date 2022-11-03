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
    func hideSortButton()
}

protocol FeedPresenter {
    func viewDidLoad()
    func getItemsCount() -> Int
    func getItem(at index: Int) -> MovieUIModel?
    func showMovieDetails(with index: Int)
    func loadMore()
    func selectSortType(_ type: MoviesSortType)
    func search(with string: String)
    func cancelSearch()
    func isSearching() -> Bool
    func getTotalItemsCount() -> Int
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
    private var isNetworkAvailable = true
    private var totalResults = 0
    
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
    
    func getItem(at index: Int) -> MovieUIModel? {
        return movies.indices.contains(index) ? movies[index] : nil
    }
    
    func showMovieDetails(with index: Int) {
        if isNetworkAvailable {
            router.showMovieDetails(with: movies[index].id)
        } else {
            showError(NetworkError.noInternetConnection)
        }
    }
    
    func loadMore() {
        if isNetworkAvailable,
           movies.count < totalResults {
            if !loadingData && searchText.isEmpty {
                pageCounter[sortType, default: 1] += 1
                fetchMovies(with: sortType, page: getPage())
            } else if !loadingData && !searchText.isEmpty {
                searchPage += 1
                fetchSearch(query: searchText, page: searchPage)
            }
        }
    }
    
    func selectSortType(_ type: MoviesSortType) {
        sortType = type
        displayMovies()
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
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1),
                                              execute: searchWorkItem)
            }
        }
    }
    
    func cancelSearch() {
        searchText = ""
        displayMovies()
    }
    
    func isSearching() -> Bool {
        return !searchText.isEmpty
    }
    
    func getTotalItemsCount() -> Int {
        return totalResults
    }
    
    // MARK: - Private Methods
    private func fetchGenres() {
        repository.fetchGenres { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.fetchMovies(with: self.sortType,
                                 page: self.getPage())
            case .failure(let error):
                self.showError(error)
                self.fetchMovies(with: self.sortType,
                                 page: self.getPage())
            }
        }
    }
    
    private func fetchMovies(with sortType: MoviesSortType,
                             page: Int,
                             completion: EmptyBlock? = nil) {
        startDataLoading()
        repository.fetchMovies(with: sortType, page: page) { [weak self] result in
            guard let self = self else { return }
            self.finishDataLoading()
            switch result {
            case .success(let movies):
                self.displayFetchedMovies(with: movies.0)
                self.totalResults = movies.1
            case .failure(let error):
                self.showError(error)
            }
            completion?()
        }
    }
    
    private func displayFetchedMovies(with data: [MovieUIModel]) {
        if isNetworkAvailable {
            moviesStorage[sortType, default: []] += data
            movies = moviesStorage[sortType, default: []]
        } else {
            movies = data
        }
        reloadData()
    }
    
    private func fetchSearch(query: String, page: Int) {
        startDataLoading()
        repository.fetchSearch(query: query, page: page) { [weak self] result in
            guard let self = self else { return }
            self.finishDataLoading()
            switch result {
            case .success(let movies):
                self.displaySearchedMovies(with: movies.0)
                self.totalResults = movies.1
            case .failure(let error):
                self.showError(error)
            }
        }
    }
    
    private func displaySearchedMovies(with data: [MovieUIModel]) {
        movies += data
        reloadData()
    }
    
    private func startSearch() {
        if searchText.isEmpty {
            displayMovies()
        } else {
            fetchSearch(query: searchText, page: searchPage)
        }
    }
    
    private func displayMovies() {
        DispatchQueue.main.async {
            self.view?.scrollToTop()
        }
        if let movies = moviesStorage[sortType] {
            self.movies = movies
            reloadData()
        } else {
            fetchMovies(with: sortType, page: getPage())
        }
    }
    
    private func startDataLoading() {
        loadingData = true
        view?.showLoadingView()
    }
    
    private func finishDataLoading() {
        loadingData = false
        view?.hideLoadingView()
    }
    
    private func showError(_ error: Error) {
        if let networkError = error as? NetworkError {
            view?.showMessage(title: "Warning",
                                   message: networkError.message)
            isNetworkAvailable = false
            view?.hideSortButton()
        } else {
            view?.showMessage(title: "Warning",
                                   message: error.localizedDescription)
        }
    }
    
    private func getPage() -> Int {
        return pageCounter[sortType, default: 1]
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.view?.reloadData()
        }
    }
}
