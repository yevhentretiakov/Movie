//
//  EmotyBlock.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 19.09.2022.
//

import Foundation

typealias EmptyBlock = () -> Void
typealias BoolBlock = (Bool) -> Void
typealias NetworkResult<T> = (Result<T, Error>) -> Void
typealias MovieDetailsResult = (Result<MovieDetailModel, Error>) -> Void
typealias MovieResult = (Result<[MovieNetworkModel], Error>) -> Void
typealias MovieTrailerResult = (Result<MovieVideoModel?, Error>) -> Void
typealias GenresResult = (Result<[GenreModel], Error>) -> Void
typealias DataBlock<T> = (Result<[T], Error>) -> Void
