//
//  DataAddable.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.10.2022.
//

import Foundation
import CoreData

enum DataObject {
    case movie(_ object: MovieUIModel)
}

protocol DataAddable {
    func add()
}

// MARK: - DataAddable
extension DataObject: DataAddable {
    func add() {
        switch self {
        case .movie(let object):
            let movie = Movie()
            movie.title = object.title
            movie.id = object.id.int64Value
            movie.backdropPath = object.backdropPath
            movie.releaseDate = object.releaseDate
            movie.voteAverage = object.voteAverage
            movie.genres = object.genres
        }
    }
}
