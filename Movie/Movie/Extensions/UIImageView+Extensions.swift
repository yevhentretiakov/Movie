//
//  UIImageView+Extensions.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 21.09.2022.
//

import UIKit

typealias ImageBlock = (UIImage?) -> Void

extension UIImageView {
    func setImage(with imageUrl: String, completion: ImageBlock? = nil) {
        DispatchQueue.global().async {
            if let url = URL(string: imageUrl), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.image = image
                    completion?(image)
                }
            } else {
                completion?(nil)
            }
        }
    }
}
