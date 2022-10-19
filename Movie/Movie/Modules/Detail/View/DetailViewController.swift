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
        presenter.showPoster()
    }
    
    @IBAction private func didTapTrailerButton(_ sender: UIButton) {
        presenter.showTrailer()
    }
}

// MARK: - DetailView
extension DetailViewController: DetailView {
    func showMessage(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    
    func displayMovie(with model: MovieDetailModel) {
        title = model.title
        posterImageView.setImage(with: model.backdropPath)
        titleLabel.text = model.title
        yearLabel.text = model.releaseDate.dateFromString(with: "yyyy-MM-dd")?.dateString(in: "dd MMM yyyy") ?? ""
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
