//
//  ApiEndpoint.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 19.09.2022.
//

import Foundation
import Alamofire

// MARK: - Enums
enum ApiEndpoint {
    case fetchPopularMovies(page: Int)
    case fetchGenres
    case fetchMovieDetails(id: Int)
    static let apiKey = "37583bb7971b4bc83cd1317e9d98a299"
    static let baseURL = "https://api.themoviedb.org/3/"
}

// MARK: - Protocols
protocol HTTPRequest {
    var url: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: URLEncoding { get }
}

// MARK: - HTTPRequest
extension ApiEndpoint: HTTPRequest {
    var url: String {
        switch self {
        case .fetchPopularMovies:
            return ApiEndpoint.baseURL
        case .fetchGenres:
            return ApiEndpoint.baseURL
        case .fetchMovieDetails(_):
            return ApiEndpoint.baseURL
        }
    }
    var path: String {
        switch self {
        case .fetchPopularMovies(let page):
            return "\(url)movie/popular?api_key=\(ApiEndpoint.apiKey)&language=en-US&page=\(page)"
        case .fetchGenres:
            return "\(url)genre/movie/list?api_key=\(ApiEndpoint.apiKey)&language=en-US"
        case .fetchMovieDetails(let id):
            return "\(url)movie/\(id)?api_key=\(ApiEndpoint.apiKey)&language=en-US"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .fetchPopularMovies:
            return .get
        case .fetchGenres:
            return .get
        case .fetchMovieDetails(_):
            return .get
        }
    }
    var headers: HTTPHeaders? {
        switch self {
        case .fetchPopularMovies:
            return nil
        case .fetchGenres:
            return nil
        case .fetchMovieDetails(_):
            return nil
        }
    }
    var parameters: Parameters? {
        switch self {
        case .fetchPopularMovies:
            return nil
        case .fetchGenres:
            return nil
        case .fetchMovieDetails(_):
            return nil
        }
    }
    var encoding: URLEncoding {
        switch self {
        case .fetchPopularMovies:
            return .default
        case .fetchGenres:
            return .default
        case .fetchMovieDetails(_):
            return .default
        }
    }
}
