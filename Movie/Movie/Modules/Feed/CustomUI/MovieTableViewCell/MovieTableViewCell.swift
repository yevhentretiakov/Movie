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
    private let posterCornerRadius: CGFloat = 10
    
    // MARK: - Internal Methods
    func configure(with model: MovieUIModel) {
        posterImageView.image = nil
        titleLabel.text = model.title
        yearLabel.text = model.releaseDate
        ratingLabel.text = model.voteAverage.toString(rounded: 1)
        genresLabel.text = model.genres.joined(separator: ", ")
        posterImageView.setImage(with: model.backdropPath)
        posterImageView.cornerRadius = posterCornerRadius
        underlayView.cornerRadius = posterCornerRadius
        underlayView.setShadow(color: .black, offset: .zero, opacity: 1, radius: 3)
    }
}
