//
//  PosterBuilder.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 22.09.2022.
//

import UIKit

// MARK: - Protocol
protocol PosterBuilder {
    func createPosterModule(with posterPath: String) -> UIViewController
}

final class DefaultPosterBuilder: PosterBuilder {
    // MARK: - Methods
    func createPosterModule(with posterPath: String) -> UIViewController {
        let view = PosterViewController()
        let router = DefaultPosterRouter(viewController: view)
        let presenter = DefaultPosterPresenter(view: view,
                                               router: router,
                                               posterPath: posterPath)
        view.presenter = presenter
        return view
    }
}
