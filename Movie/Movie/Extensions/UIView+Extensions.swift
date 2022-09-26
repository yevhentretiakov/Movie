//
//  UIView+Extensions.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 26.09.2022.
//

import UIKit

extension UIView {
    var cornerRadius: CGFloat {
        set {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = newValue
        }
        get {
            self.layer.cornerRadius
        }
    }
    
    func makeRounded() {
        self.cornerRadius = self.frame.height / 2
    }
    
    func setShadow(color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25),
                   offset: CGSize = CGSize(width: 0.0, height: 2.0),
                   opacity: Float = 1.0,
                   radius: CGFloat = 2) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
}
