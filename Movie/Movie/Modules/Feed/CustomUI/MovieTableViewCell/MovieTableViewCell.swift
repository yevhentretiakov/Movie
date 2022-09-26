//
//  MovieTableViewCell.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import UIKit
import Kingfisher

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
        posterImageView.kf.setImage(with: URL(string: "\(ApiEndpoint.imagesBaseURL)\(model.backdropPath)"))
        underlayView.setShadow(color: .black, offset: .zero, opacity: 1, radius: 3)
    }
}
