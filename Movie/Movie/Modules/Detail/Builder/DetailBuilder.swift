//
//  DetailBuilder.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 21.09.2022.
//

import UIKit

// MARK: - Protocol
protocol DetailBuilder {
    func createDetailModule(withMovieId id: Int) -> UIViewController
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
}
