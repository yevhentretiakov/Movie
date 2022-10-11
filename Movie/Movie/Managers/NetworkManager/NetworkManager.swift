//
//  NetworkService.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 19.09.2022.
//

import Foundation
import Alamofire

// MARK: - Protocols
protocol NetworkManager {
    func request<T: Decodable>(_ type: T.Type, from endpoint: ApiEndpoint, completion: @escaping NetworkResult<T>)
    func cancel()
}

final class DefaultNetworkManager: NetworkManager {
    // MARK: - Properties
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private var request: DataRequest?
    
    // MARK: - Methods
    func request<T: Decodable>(_ type: T.Type, from endpoint: ApiEndpoint, completion: @escaping NetworkResult<T>) {
        request = AF.request(endpoint.url,
                   method: endpoint.method,
                   parameters: endpoint.parameters,
                   encoding: endpoint.encoding,
                   headers: endpoint.headers)
        .responseDecodable(of: type, decoder: DefaultNetworkManager.decoder) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if let urlError = error.underlyingError as? URLError, urlError.code == URLError.Code.notConnectedToInternet{
                    completion(.failure(NetworkError.noInternetConnection))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func cancel() {
        request?.cancel()
    }
}
