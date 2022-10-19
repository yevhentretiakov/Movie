//
//  Double+Extensions.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 21.09.2022.
//

import Foundation

extension Double {
    var stringValue: String {
        return String(self)
    }
    
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func toString(rounded places: Int) -> String {
        return String(format: "%.\(places)f", self)
    }
}
