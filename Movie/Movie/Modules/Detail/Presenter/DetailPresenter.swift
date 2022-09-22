//
//  DetailPresenter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 21.09.2022.
//

import Foundation

// MARK: - Protocols
protocol DetailView: AnyObject {
    func showMessage(title: String, message: String)
    func configureMovie(with model: MovieDetailModel)
}

protocol DetailPresenter {
    func viewDidLoad()
    func didTapPosterImageView()
    func didTapTrailerButton()
    func isContainTrailer() -> Bool
}

final class DefaultDetailPresenter: DetailPresenter {
    // MARK: - Properties
    private weak var view: DetailView?
    private let router: DetailRouter
    private let repository: DetailRepository
    private let moviewId: Int
    private var movieDetail: MovieDetailModel?
    private let trailerPath = "https://devstreaming-cdn.apple.com/videos/wwdc/2022/110929/1/E9996C71-5D71-46C7-BC47-4A26302DA7D6/cmaf.m3u8"
    
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
    }
    
    func didTapPosterImageView() {
        if let posterPath = movieDetail?.posterPath {
            router.showPoster(from: posterPath)
        }
    }
    
    func didTapTrailerButton() {
        router.showVideo(from: trailerPath)
    }
    
    func isContainTrailer() -> Bool {
        return !trailerPath.isEmpty
    }
    
    // MARK: - Private Methods
    private func fetchMovieDetails(with id: Int) {
        repository.fetchMovieDetails(with: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movie):
                if let movie = movie {
                    self.movieDetail = movie
                    DispatchQueue.main.async {
                        self.view?.configureMovie(with: movie)
                    }
                }  else {
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
