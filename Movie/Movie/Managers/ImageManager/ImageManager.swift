//
//  ImageManager.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 07.10.2022.
//

import Foundation

enum ImageResolution {
    case low, high
    var path: String {
        switch self {
        case .low:
            return "w500/"
        case .high:
            return "original/"
        }
    }
}

protocol ImageManager {
    func buildURL(with path: String, resolution: ImageResolution) -> URL?
}

class DefaultImageManager: ImageManager {
    // MARK: - Properties
    static let shared = DefaultImageManager()
    private let imagesBaseURL = "https://image.tmdb.org/t/p/"
    
    // MARK: - Internal Methods
    func buildURL(with path: String, resolution: ImageResolution) -> URL? {
        return URL(string: imagesBaseURL + resolution.path + path)
    }
}
