//
//  NetworkError.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 26.09.2022.
//

import Foundation

enum NetworkError: Error {
    case noInternetConnection
    
    var message: String {
        switch self {
        case .noInternetConnection:
            return "You are offline. Please, enable your Wi-Fi or connect using cellular data."
        }
    }
}
