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
    case fetchSearch(query: String, page: Int)
}

// MARK: - Protocols
protocol HTTPRequest {
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

// MARK: - HTTPRequest
extension ApiEndpoint: HTTPRequest {
    // MARK: - Properties
    var baseUrl: String {
        switch self {
        case .fetchMovies, .fetchGenres, .fetchMovieDetails, .fetchMovieVideos, .fetchSearch:
            return .baseURL
        }
    }
    var path: String {
        switch self {
        case .fetchMovies(let sortType, _):
            return "movie/\(sortType.path)"
        case .fetchGenres:
            return "genre/movie/list"
        case .fetchMovieDetails(let id):
            return "movie/\(id)"
        case .fetchMovieVideos(let id):
            return "movie/\(id)/videos"
        case .fetchSearch:
            return "search/movie"
        }
    }
    var url: String {
        switch self {
        case .fetchMovies, .fetchGenres, .fetchMovieDetails, .fetchMovieVideos, .fetchSearch:
            return baseUrl + path
        }
    }
    var method: HTTPMethod {
        switch self {
        case .fetchMovies, .fetchGenres, .fetchMovieDetails, .fetchMovieVideos, .fetchSearch:
            return .get
        }
    }
    var headers: HTTPHeaders? {
        switch self {
        case .fetchMovies, .fetchGenres, .fetchMovieDetails, .fetchMovieVideos, .fetchSearch:
            return nil
        }
    }
    var parameters: Parameters? {
        var parameters: [String: Any] = .defaultParameters
        switch self {
        case .fetchMovies(_, let page):
            parameters["page"] = page.stringValue
            return parameters
        case .fetchSearch(let query, let page):
            parameters["query"] = query
            parameters["page"] = page.stringValue
            return parameters
        case .fetchGenres, .fetchMovieDetails(_), .fetchMovieVideos(_):
            return .defaultParameters
        }
    }
    var encoding: ParameterEncoding {
        switch self {
        case .fetchMovies, .fetchGenres, .fetchMovieDetails, .fetchMovieVideos, .fetchSearch:
            return URLEncoding.default
        }
    }
}

// MARK: - Constants
private extension String {
    static let apiKey = "37583bb7971b4bc83cd1317e9d98a299"
    static let baseURL = "https://api.themoviedb.org/3/"
}

private extension Dictionary<String, Any> {
    static let defaultParameters = ["api_key": .apiKey,
                                    "language": "en-US"]
}
