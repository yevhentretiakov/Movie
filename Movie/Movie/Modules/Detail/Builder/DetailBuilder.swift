//
//  DetailBuilder.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 21.09.2022.
//

import UIKit
import AVKit
import AVFoundation

// MARK: - Protocol
protocol DetailBuilder {
    func createDetailModule(withMovieId id: Int) -> UIViewController
    func createPlayer(with url: String) -> AVPlayerViewController
}

final class DefaultDetailBuilder: DetailBuilder {
    // MARK: - Internal Methods
    func createDetailModule(withMovieId id: Int) -> UIViewController {
        let view = DetailViewController()
        let router = DefaultDetailRouter(viewController: view)
        let repository = DefaultDetailRepository()
        let presenter = DefaultDetailPresenter(view: view, moviewId: id, router: router, repository: repository)
        view.presenter = presenter
        return view
    }
    
    func createPlayer(with url: String) -> AVPlayerViewController {
        let url = URL(string: url)!
        let player = AVPlayer(url: url)
        let view = AVPlayerViewController()
        view.player = player
        return view
    }
}
