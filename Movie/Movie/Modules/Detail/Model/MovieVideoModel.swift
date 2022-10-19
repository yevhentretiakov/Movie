//
//  MovieVideoModel.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 30.09.2022.
//

import Foundation

struct MovieVideosResponse: Codable {
    let results: [MovieVideoModel]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decodeIfPresent([MovieVideoModel].self, forKey: .results) ?? .emptyList
    }
}

struct MovieVideoModel: Codable {
    let key: String
    let type: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decodeIfPresent(String.self, forKey: .key) ?? .empty
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? .empty
    }
}
