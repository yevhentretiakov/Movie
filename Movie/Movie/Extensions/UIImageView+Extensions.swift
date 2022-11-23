//
//  UIImageView.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 07.10.2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with remotePath: String,
                  resolution: ImageResolution = .low,
                  completion: ImageBlock? = nil) {
        self.kf.setImage(with: DefaultImageManager.shared.buildURL(with: remotePath,
                                                                   resolution: resolution),
                         placeholder: UIImage(named: "ImagePlaceholder")) { result in
            if let completion = completion {
                switch result {
                case .success(let result):
                        completion(.success(result.image))
                case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
}

