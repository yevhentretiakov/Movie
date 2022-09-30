//
//  MovieVideoModel.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 30.09.2022.
//

import Foundation

struct MovieVideosResponse: Codable {
    let results: [MovieVideoModel]
}

struct MovieVideoModel: Codable {
    let key: String
    let type: String
}
