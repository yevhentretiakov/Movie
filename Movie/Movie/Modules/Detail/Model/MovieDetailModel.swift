//
//  MovieDetailModel.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 21.09.2022.
//

import Foundation

// MARK: - Response Data
struct MovieDetailModel: Codable {
    let title: String
    let overview: String
    let releaseDate: String
    let backdropPath: String
    let genres: [GenreModel]
    let voteAverage: Double
    let productionCountries: [CountryModel]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? ""
        self.genres = try container.decodeIfPresent([GenreModel].self, forKey: .genres) ?? []
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0
        self.productionCountries = try container.decodeIfPresent([CountryModel].self, forKey: .productionCountries) ?? []
    }
}

struct CountryModel: Codable {
    let name: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}
