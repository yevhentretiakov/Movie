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
    
    // MARK: - Private Methods
    @IBAction private func didTapCloseButton(_ sender: UIButton) {
        presenter.close()
    }
}

// MARK: - PosterView
extension PosterViewController: PosterView {
    func configurePoster(with path: String) {
        posterImageView.setImage(with: path, resolution: .high)
    }
}

// MARK: - UIScrollViewDelegate
extension PosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return posterImageView
    }
}
