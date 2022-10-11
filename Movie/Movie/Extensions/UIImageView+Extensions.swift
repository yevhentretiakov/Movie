//
//  UIImageView.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 07.10.2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with remotePath: String, resolution: ImageResolution = .low) {
        self.kf.setImage(with: DefaultImageManager.shared.buildURL(with: remotePath,
                                                                   resolution: resolution))
    }
}
