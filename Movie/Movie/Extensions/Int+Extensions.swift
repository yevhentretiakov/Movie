//
//  Int+Extensions.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 06.10.2022.
//

import Foundation

extension Int {
    var stringValue: String {
        return String(self)
    }
    
    var int64Value: Int64 {
        return Int64(self)
    }
}

extension Int64 {
    var intValue: Int {
        return Int(self)
    }
}

