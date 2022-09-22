//
//  PosterViewController.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 22.09.2022.
//

import UIKit

final class PosterViewController: UIViewController {
    // MARK: - Properties
    var presenter: PosterPresenter!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupScrollView()
    }
    
    // MARK: - Internal Methods
    private func setupScrollView() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
}

// MARK: - PosterView
extension PosterViewController: PosterView {
    func configurePoster(with path: String) {
        posterImageView.setImage(with: "https://image.tmdb.org/t/p/w500/\(path)")
    }
}

// MARK: - UIScrollViewDelegate
extension PosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return posterImageView
    }
}
