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
    @IBOutlet private weak var topInfoStackView: UIStackView!
    @IBOutlet private weak var bottomInfoStackView: UIStackView!
    @IBOutlet private weak var infoStackView: UIStackView!
    
    private let posterCornerRadius: CGFloat = 10
    private let gradientColors: [UIColor] = [.black.withAlphaComponent(0.8),
                                             .black.withAlphaComponent(0.7),
                                             .black.withAlphaComponent(0.5),
                                             .black.withAlphaComponent(0.3),
                                             .black.withAlphaComponent(0.1),
                                             .black.withAlphaComponent(0)]
    private let gradientLocations: [NSNumber] = [0, 0.2, 0.4, 0.6, 0.8, 1]
    
    // MARK: - Life Cycle Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        topInfoStackView.setGradient(with: gradientColors,
                                     direction: .topToBottom,
                                     locations: gradientLocations)
        bottomInfoStackView.setGradient(with: gradientColors,
                                        direction: .bottomToTop,
                                        locations: gradientLocations)
    }
    
    // MARK: - Internal Methods
    func configure(with model: MovieUIModel) {
        posterImageView.image = nil
        titleLabel.text = model.title
        yearLabel.text = model.releaseDate.formatDateString(with: "dd MMMM yyyy")
        ratingLabel.text = model.voteAverage.toString(rounded: 1)
        genresLabel.text = model.genres.joined(separator: ", ")
        posterImageView.setImage(with: model.backdropPath)
        posterImageView.cornerRadius = posterCornerRadius
        infoStackView.cornerRadius = posterCornerRadius
        selectionStyle = .none
    }
}
