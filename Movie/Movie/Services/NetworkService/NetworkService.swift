//
//  NetworkService.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 19.09.2022.
//

import Foundation
import Alamofire

typealias NetworkResponse<T> = (DataResponse<T, AFError>) -> Void

// MARK: - Protocols
protocol NetworkService {
    func request<T: Decodable>(_ type: T.Type, from endpoint: ApiEndpoint, completion: @escaping NetworkResponse<T>)
}

final class DefaultNetworkService: NetworkService {
    // MARK: - Properties
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // MARK: - Methods
    func request<T: Decodable>(_ type: T.Type, from endpoint: ApiEndpoint, completion: @escaping NetworkResponse<T>) {
        AF.request(endpoint.path,
                   method: endpoint.method,
                   parameters: endpoint.parameters,
                   encoding: endpoint.encoding,
                   headers: endpoint.headers)
        .responseDecodable(of: type, decoder: DefaultNetworkService.decoder, completionHandler: completion)
    }
}
