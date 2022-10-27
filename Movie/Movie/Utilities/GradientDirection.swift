//
//  GradientDirection.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 26.10.2022.
//

import Foundation

protocol Line {
    var startPoint: CGPoint { get }
    var endPoint: CGPoint { get }
}

enum GradientDirection {
    case vertical
    case horizontal
}

extension GradientDirection: Line {
    var startPoint: CGPoint {
        switch self {
        case .horizontal:
            return CGPoint(x: 0, y: 1)
        case .vertical:
            return CGPoint(x: 0, y: 0)
        }
    }
    
    var endPoint: CGPoint {
        switch self {
        case .horizontal:
            return CGPoint(x: 1, y: 1)
        case .vertical:
            return CGPoint(x: 0, y: 1)
        }
    }
}
