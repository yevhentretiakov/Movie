//
//  MovieModel.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import Foundation

// MARK: - Response Data
struct MoviesResponse: Codable {
    let results: [MovieNetworkModel]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decodeIfPresent([MovieNetworkModel].self, forKey: .results) ?? .emptyList
    }
}

struct MovieNetworkModel: Codable {
    let genreIds: [Int]
    let id: Int
    let voteAverage: Double
    let title: String
    let backdropPath: String
    let releaseDate: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds) ?? .emptyList
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? .zero
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? .zero
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? .empty
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? .empty
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? .empty
    }
}

// MARK: - UI Model
struct MovieUIModel: Equatable {
    let genres: [String]
    let id: Int
    let voteAverage: Double
    let title: String
    let backdropPath: String
    let releaseDate: String
}
