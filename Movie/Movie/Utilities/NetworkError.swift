//
//  NetworkError.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 26.09.2022.
//

import Foundation

enum NetworkError: String {
    case tryLater = "Please try again later..."
    case offline = "You are offline. Please, enable your Wi-Fi or connect using cellular data."
}
