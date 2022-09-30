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
    case fetchMovies(sortType: MoviesSortType, page: Int)
    case fetchGenres
    case fetchMovieDetails(id: Int)
    case fetchMovieVideos(id: Int)
    static let apiKey = "37583bb7971b4bc83cd1317e9d98a299"
    static let baseURL = "https://api.themoviedb.org/3/"
    static let imagesBaseURL = "https://image.tmdb.org/t/p/w500/"
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
        case .fetchMovies:
            return ApiEndpoint.baseURL
        case .fetchGenres:
            return ApiEndpoint.baseURL
        case .fetchMovieDetails(_):
            return ApiEndpoint.baseURL
        case .fetchMovieVideos(_):
            return ApiEndpoint.baseURL
        }
    }
    var path: String {
        switch self {
        case .fetchMovies(let sortType, _):
            return "\(url)movie/\(sortType.rawValue)"
        case .fetchGenres:
            return "\(url)genre/movie/list"
        case .fetchMovieDetails(let id):
            return "\(url)movie/\(id)"
        case .fetchMovieVideos(let id):
            return "\(url)movie/\(id)/videos"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .fetchMovies:
            return .get
        case .fetchGenres:
            return .get
        case .fetchMovieDetails(_):
            return .get
        case .fetchMovieVideos(_):
            return .get
        }
    }
    var headers: HTTPHeaders? {
        switch self {
        case .fetchMovies:
            return nil
        case .fetchGenres:
            return nil
        case .fetchMovieDetails(_):
            return nil
        case .fetchMovieVideos(_):
            return nil
        }
    }
    var parameters: Parameters? {
        switch self {
        case .fetchMovies(_, let page):
            return ["api_key": ApiEndpoint.apiKey,
                    "language": "en-US",
                    "page": page]
        case .fetchGenres:
            return ["api_key": ApiEndpoint.apiKey,
                    "language": "en-US"]
        case .fetchMovieDetails(_):
            return ["api_key": ApiEndpoint.apiKey,
                    "language": "en-US"]
        case .fetchMovieVideos(_):
            return ["api_key": ApiEndpoint.apiKey,
                    "language": "en-US"]
        }
    }
    var encoding: URLEncoding {
        switch self {
        case .fetchMovies:
            return .default
        case .fetchGenres:
            return .default
        case .fetchMovieDetails(_):
            return .default
        case .fetchMovieVideos(_):
            return .default
        }
    }
}
