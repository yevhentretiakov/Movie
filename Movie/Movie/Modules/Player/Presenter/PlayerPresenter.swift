//
//  PlayerPresenter.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 30.09.2022.
//

import Foundation

// MARK: - Protocols
protocol PlayerView: AnyObject, Loadable {
    func loadVideo(with id: String)
}

protocol PlayerPresenter {
    func viewDidLoad()
    func close()
}

final class DefaultPlayerPresenter: PlayerPresenter {
    // MARK: - Properties
    private weak var view: PlayerView?
    private let router: PlayerRouter
    private var videoId: String
    
    // MARK: - Life Cycle Methods
    init(view: PlayerView,
         router: PlayerRouter,
         videoId: String) {
        self.view = view
        self.router = router
        self.videoId = videoId
    }
    
    // MARK: - Internal Methods
    func viewDidLoad() {
        view?.showLoadingView()
        view?.loadVideo(with: videoId)
    }
    
    func close() {
        router.close()
    }
}
