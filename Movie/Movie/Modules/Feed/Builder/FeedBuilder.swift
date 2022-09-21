//
//  DefaultFeedBuilder.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import UIKit

// MARK: - Protocols
protocol FeedBuilder {
    func createFeedModule() -> UIViewController
}

final class DefaultFeedBuilder: FeedBuilder {
    // MARK: - Methods
    func createFeedModule() -> UIViewController {
        let view = FeedViewController()
        let router = DefaultFeedRouter(viewController: view)
        let repository = DefaultFeedRepository()
        let presenter = DefaultFeedPresenter(view: view, router: router, repository: repository)
        view.presenter = presenter
        return UINavigationController(rootViewController: view)
    }
}
