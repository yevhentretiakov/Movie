//
//  DetailViewController.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 21.09.2022.
//

import UIKit
import Kingfisher

final class DetailViewController: UIViewController {
    // MARK: - Properties
    var presenter: DetailPresenter!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var trailerButton: UIButton!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    // MARK: - Private Methods
    @IBAction private func didTapPosterImageView(_ sender: UITapGestureRecognizer) {
        presenter.didTapPosterImageView()
    }
    
    @IBAction private func didTapTrailerButton(_ sender: UIButton) {
        presenter.didTapTrailerButton()
    }
    
    private func setupTrailerButton() {
        trailerButton.makeRounded()
        if !presenter.isHaveTrailer() {
            trailerButton.isHidden = true
        }
    }
}

// MARK: - DetailView
extension DetailViewController: DetailView {
    func showMessage(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    func configureMovie(with model: MovieDetailModel) {
        title = model.title
        posterImageView.kf.setImage(with: URL(string: "\(ApiEndpoint.imagesBaseURL)\(model.backdropPath ?? "")"))
        titleLabel.text = model.title
        yearLabel.text = model.releaseDate
        genreLabel.text = model.genres.map({ $0.name }).joined(separator: ", ")
        ratingLabel.text = model.voteAverage.rounded(toPlaces: 1).toString
        countryLabel.text = model.productionCountries.map({ $0.iso }).joined(separator: ", ")
        descriptionLabel.text = model.overview
        setupTrailerButton()
    }
    
    func showLoadingIndicator() {
        showLoadingView()
    }
    
    func hideLoadingIndicator() {
        hideLoadingView()
    }
}
