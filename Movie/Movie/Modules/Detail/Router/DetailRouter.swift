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
    func showVideo(from url: String)
    func close()
}

final class DefaultDetailRouter: DefaultBaseRouter, DetailRouter {
    // MARK: - Internal Methods
    func showPoster(from path: String) {
        let viewController = DefaultPosterBuilder().createPosterModule(with: path)
        show(viewController: viewController, isModal: true, animated: true)
    }
    
    func showVideo(from url: String) {
        let viewController = DefaultDetailBuilder().createPlayer(with: url)
        show(viewController: viewController, isModal: true, animated: true) {
            viewController.player?.play()
        }
    }
    
    func close() {
        close(animated: true)
    }
}
