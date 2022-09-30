//
//  DetailRouter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 21.09.2022.
//

import Foundation

// MARK: - Protocols
protocol DetailRouter {
    func showPoster(from path: String)
    func showVideo(with id: String)
    func close()
}

final class DefaultDetailRouter: DefaultBaseRouter, DetailRouter {
    // MARK: - Internal Methods
    func showPoster(from path: String) {
        let viewController = DefaultPosterBuilder().createPosterModule(with: path)
        show(viewController: viewController, isModal: true, animated: true)
    }
    
    func showVideo(with id: String) {
        let viewController = DefaultPlayerBuilder().createPlayerModule(with: id)
        show(viewController: viewController, isModal: true, animated: true)
    }
    
    func close() {
        close(animated: true)
    }
}
