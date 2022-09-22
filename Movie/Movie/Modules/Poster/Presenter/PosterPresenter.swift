//
//  PosterPresenter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 22.09.2022.
//

import Foundation

// MARK: - Protocols
protocol PosterView: AnyObject {
    func configurePoster(with path: String)
}

protocol PosterPresenter {
    func viewDidLoad()
}

final class DefaultPosterPresenter: PosterPresenter {
    // MARK: - Properties
    private weak var view: PosterView?
    private let router: PosterRouter
    var posterPath: String
    
    // MARK: - Life Cycle Methods
    init(view: PosterView, router: PosterRouter, posterPath: String) {
        self.view = view
        self.router = router
        self.posterPath = posterPath
    }
    
    // MARK: - Internal Methods
    func viewDidLoad() {
        view?.configurePoster(with: posterPath)
    }
    
    // MARK: - Private Methods
    
}
