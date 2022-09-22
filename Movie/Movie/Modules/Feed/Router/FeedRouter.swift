//
//  FeedRouter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import Foundation

// MARK: - Protocols
protocol FeedRouter {
    func showMovieDetails(with id: Int)
}

final class DefaultFeedRouter: DefaultBaseRouter, FeedRouter {
    // MARK: - Internal Methods
    func showMovieDetails(with id: Int) {
        let viewController = DefaultDetailBuilder().createDetailModule(withMovieId: id)
        show(viewController: viewController, isModal: false, animated: true)
    }
}
