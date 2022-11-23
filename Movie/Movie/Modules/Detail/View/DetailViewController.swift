//
//  DetailViewController.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 21.09.2022.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: - Properties
    var presenter: DetailPresenter!
    private var loadingView: UIView?
    @IBOutlet weak var posterImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var trailerButton: UIButton!
    @IBOutlet private weak var bottomGradientView: UIView!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var infoStackView: UIStackView!
    
    private let posterImageDefaultHeight: CGFloat = 250
    private let parallaxImageMinHeight: CGFloat = 100
    private let scrollViewBottomPadding: CGFloat = 100
    private let spaceBetweenImageAndInfo: CGFloat = 10
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomGradientView()
        setupNavigationBar()
        setupScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    // MARK: - Private Methods
    @IBAction private func didTapPosterImageView(_ sender: UITapGestureRecognizer) {
        presenter.showPoster()
    }
    
    @IBAction private func didTapTrailerButton(_ sender: UIButton) {
        presenter.showTrailer()
    }
    
    private func setupBottomGradientView() {
        bottomGradientView.setGradient(with: [.systemBackground,
                                              .systemBackground.withAlphaComponent(0)],
                                       direction: .bottomToTop)
    }
    
    private func setupNavigationBar() {
        title = .empty
    }
    
    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        scrollView.alpha = 0
    }
}

// MARK: - UIScrollViewDelegate
extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height != 0 {
            let offset = scrollView.contentOffset
            if offset.y < 0.0 {
                posterImageViewHeightConstraint.constant = posterImageDefaultHeight
                var transform = CATransform3DTranslate(CATransform3DIdentity, 0, offset.y, 0)
                let scaleFactor = 1 + (-1 * offset.y / (posterImageViewHeightConstraint.constant / 2))
                transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1)
                posterImageView.layer.transform = transform
            }
        }
    }
}

// MARK: - DetailView
extension DetailViewController: DetailView {
    func showMessage(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    func displayMovie(with model: MovieDetailModel) {
        posterImageView.setImage(with: model.backdropPath, resolution: .high) { [weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.5) {
                self.scrollView.alpha = 1
            }
            self.hideLoadingView()
        }
        titleLabel.text = model.title
        yearLabel.text = model.releaseDate.formatDateString(with: "dd MMMM yyyy")
        genreLabel.text = model.genres.map({ $0.name }).joined(separator: ", ")
        ratingLabel.text = model.voteAverage.toString(rounded: 1)
        countryLabel.text = model.productionCountries.map({ $0.name }).joined(separator: ", ")
        descriptionLabel.text = model.overview
    }
    
    func updateTrailerConditions(_ trailerExists: Bool) {
        if trailerExists {
            trailerButton.isHidden = false
        }
    }
}
