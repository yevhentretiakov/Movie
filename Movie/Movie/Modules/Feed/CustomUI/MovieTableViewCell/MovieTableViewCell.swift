//
//  MovieTableViewCell.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import UIKit

final class MovieTableViewCell: BaseTableViewCell {
    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var underlayView: UIView!
    
    // MARK: - Internal Methods
    func configure(with model: MovieUIModel) {
        titleLabel.text = model.title
        yearLabel.text = model.releaseDate
        ratingLabel.text = model.voteAverage.toString
        genresLabel.text = model.genres.joined(separator: ", ")
        posterImageView.setImage(with: "https://image.tmdb.org/t/p/w500/\(model.backdropPath)")
        setupShadow()
    }
    
    private func setupShadow() {
        underlayView.layer.shadowColor = UIColor.black.cgColor
        underlayView.layer.shadowOpacity = 1
        underlayView.layer.shadowOffset = .zero
        underlayView.layer.shadowRadius = 3
    }
}
