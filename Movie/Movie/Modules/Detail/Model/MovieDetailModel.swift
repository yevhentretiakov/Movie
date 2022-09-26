//
//  MovieDetailModel.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 21.09.2022.
//

import Foundation

struct MovieDetailModel: Codable {
    let title: String
    let overview: String
    let releaseDate: String
    let backdropPath: String?
    let posterPath: String
    let genres: [GenreModel]
    let voteAverage: Double
    let productionCountries: [CountryModel]
}

struct CountryModel: Codable {
    let iso: String
    enum CodingKeys : String, CodingKey {
        case iso = "iso31661"
    }
}
