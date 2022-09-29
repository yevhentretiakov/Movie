//
//  EmotyBlock.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 19.09.2022.
//

import Foundation

typealias EmptyBlock = () -> Void
typealias MovieDetailsResult = (Result<MovieDetailModel?, Error>) -> Void
typealias MovieResult = (Result<[MovieNetworkModel]?, Error>) -> Void
typealias GenresResult = (Result<[GenreModel]?, Error>) -> Void
