//
//  PosterRouter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 22.09.2022.
//

import Foundation

// MARK: - Protocols
protocol PosterRouter {
    func close()
}

final class DefaultPosterRouter: DefaultBaseRouter, PosterRouter {
    // MARK: - Internal Methods
    func close() {
        close(animated: true)
    }
}
