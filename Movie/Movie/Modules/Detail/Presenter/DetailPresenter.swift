//
//  DetailPresenter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 21.09.2022.
//

import Foundation

// MARK: - Protocols
protocol DetailView: AnyObject, Loadable {
    func showMessage(title: String, message: String)
    func displayMovie(with model: MovieDetailModel)
    func updateTrailerConditions(_ trailerExists: Bool)
}

protocol DetailPresenter {
    func viewDidLoad()
    func showPoster()
    func showTrailer()
}

final class DefaultDetailPresenter: DetailPresenter {
    // MARK: - Properties
    private weak var view: DetailView?
    private let router: DetailRouter
    private let repository: DetailRepository
    private let movieId: Int
    private var videoId: String?
    private var movie: MovieDetailModel?
    
    // MARK: - Life Cycle Methods
    init(view: DetailView,
         movieId: Int,
         router: DetailRouter,
         repository: DetailRepository) {
        self.view = view
        self.movieId = movieId
        self.router = router
        self.repository = repository
    }
    
    // MARK: - Internal Methods
    func viewDidLoad() {
        showMovieDetails()
    }
    
    func showPoster() {
        if let imagePath = movie?.backdropPath {
            router.showPoster(from: imagePath)
        }
    }
    
    func showTrailer() {
        if let videoId = videoId {
            router.showVideo(with: videoId)
        }
    }
    
    // MARK: - Private Methods
    private func showMovieDetails() {
        let dispatchGroup = DispatchGroup()
        view?.showLoadingView()
        
        dispatchGroup.enter()
        fetchMovieDetails(with: movieId) {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchMovieTrailer(with: movieId) {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global(qos: .userInteractive)) {
            DispatchQueue.main.async {
                if let movie = self.movie {
                    self.view?.displayMovie(with: movie)
                }
                self.view?.updateTrailerConditions(self.videoId != nil)
                self.view?.hideLoadingView()
            }
        }
    }
    
    private func fetchMovieDetails(with id: Int, completion: EmptyBlock? = nil) {
        repository.fetchMovieDetails(with: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movie):
                self.movie = movie
            case .failure(let error):
                if let error = error as? NetworkError {
                    self.view?.showMessage(title: "Error",
                                           message: error.message)
                } else {
                    self.view?.showMessage(title: "Error",
                                           message: error.localizedDescription)
                }
                self.router.close()
            }
            completion?()
        }
    }
    
    private func fetchMovieTrailer(with id: Int, completion: EmptyBlock? = nil) {
        repository.fetchMovieTrailer(with: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let trailer):
                if trailer != nil {
                    self.videoId = trailer?.key
                }
            case .failure:
                self.videoId = nil
            }
            completion?()
        }
    }
}
