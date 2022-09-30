//
//  PlayerViewController.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 30.09.2022.
//

import UIKit
import YouTubeiOSPlayerHelper

final class PlayerViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var playerView: YTPlayerView!
    var presenter: PlayerPresenter!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupPlayerView()
    }
    
    // MARK: - Private Methods
    private func setupPlayerView() {
        playerView.delegate = self
    }
}

// MARK: - PlayerView
extension PlayerViewController: PlayerView {
    func loadVideo(with id: String) {
        playerView.load(withVideoId: id)
    }
}

// MARK: - YTPlayerViewDelegate
extension PlayerViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
