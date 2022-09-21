//
//  FeedRouter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import Foundation

// MARK: - Protocols
protocol FeedRouter {
    func showMovieDetails()
}

final class DefaultFeedRouter: DefaultBaseRouter, FeedRouter {
    func showMovieDetails() {
      
    }
}
