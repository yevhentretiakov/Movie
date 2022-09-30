//
//  DetailPresenter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 21.09.2022.
//

import Foundation

// MARK: - Protocols
protocol DetailView: AnyObject, LoadingView {
    func showMessage(title: String, message: String)
    func configureMovie(with model: MovieDetailModel)
    func hideTrailerButton()
}

protocol DetailPresenter {
    func viewDidLoad()
    func didTapPosterImageView()
    func didTapTrailerButton()
}

final class DefaultDetailPresenter: DetailPresenter {
    // MARK: - Properties
    private weak var view: DetailView?
    private let router: DetailRouter
    private let repository: DetailRepository
    private let moviewId: Int
    private var posterPath: String?
    private var videoId: String?
    
    // MARK: - Life Cycle Methods
    init(view: DetailView, moviewId: Int, router: DetailRouter, repository: DetailRepository) {
        self.view = view
        self.moviewId = moviewId
        self.router = router
        self.repository = repository
    }
    
    // MARK: - Internal Methods
    func viewDidLoad() {
        fetchMovieDetails(with: moviewId)
        fetchMovieTrailer(with: moviewId)
    }
    
    func didTapPosterImageView() {
        if let posterPath = posterPath {
            router.showPoster(from: posterPath)
        }
    }
    
    func didTapTrailerButton() {
        if let videoId = videoId {
            router.showVideo(with: videoId)
        }
    }
    
    // MARK: - Private Methods
    private func fetchMovieDetails(with id: Int) {
        view?.showLoadingView()
        repository.fetchMovieDetails(with: id) { [weak self] result in
            guard let self = self else { return }
            self.view?.hideLoadingView()
            switch result {
            case .success(let movie):
                self.posterPath = movie.posterPath
                DispatchQueue.main.async {
                    self.view?.configureMovie(with: movie)
                }
            case .failure(let error):
                DefaultNetworkMonitor.shared.isReachable { [weak self] status in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if status {
                            self.view?.showMessage(title: "Error", message: error.localizedDescription)
                        } else {
                            self.view?.showMessage(title: "Error", message: NetworkError.noInternetConnection.rawValue)
                            self.router.close()
                        }
                    }
                }
            }
        }
    }
    
    private func fetchMovieTrailer(with id: Int) {
        repository.fetchMovieTrailer(with: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let trailer):
                if trailer != nil {
                    self.videoId = trailer?.key
                } else {
                    self.view?.hideTrailerButton()
                }
            case .failure(_):
                self.view?.hideTrailerButton()
            }
        }
    }
}
