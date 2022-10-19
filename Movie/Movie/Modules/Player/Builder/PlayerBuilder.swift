//
//  TrailerBuilder.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 30.09.2022.
//

import UIKit

// MARK: - Protocol
protocol PlayerBuilder {
    func createPlayerModule(with videoId: String) -> UIViewController
}

final class DefaultPlayerBuilder: PlayerBuilder {
    // MARK: - Internal Methods
    func createPlayerModule(with videoId: String) -> UIViewController {
        let view = PlayerViewController()
        let router = DefaultPlayerRouter(viewController: view)
        let presenter = DefaultPlayerPresenter(view: view,
                                               router: router,
                                               videoId: videoId)
        view.presenter = presenter
        return view
    }
}

