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
    private var loadingView: UIView?
    @IBOutlet private weak var closeButton: UIButton!
    
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
    
    @IBAction private func didTapCloseButton(_ sender: UIButton) {
        presenter.close()
    }
}

// MARK: - PlayerView
extension PlayerViewController: PlayerView {
    func loadVideo(with id: String) {
        playerView.load(withVideoId: id)
    }
    
    func showLoadingView() {
        let loadingView = UIView(frame: self.view.bounds)
        loadingView.backgroundColor = .black
        loadingView.alpha = 1
        loadingView.tag = TagConstants.loadingViewTag
        
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = loadingView.center
        
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
        
        view.bringSubviewToFront(closeButton)
    }
}

// MARK: - YTPlayerViewDelegate
extension PlayerViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        hideLoadingView()
        playerView.playVideo()
    }
}
