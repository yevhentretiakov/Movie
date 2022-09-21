//
//  MovieModel.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import Foundation

struct MoviesResponse: Codable {
    let results: [MovieNetworkModel]
}

struct MovieNetworkModel: Codable {
    let genreIds: [Int]
    let id: Int
    let voteAverage: Double
    let title: String
    let posterPath: String
    let releaseDate: String
}

struct MovieUIModel: Codable {
    let genres: [String]
    let id: Int
    let voteAverage: Double
    let title: String
    let posterPath: String
    let releaseDate: String
}
