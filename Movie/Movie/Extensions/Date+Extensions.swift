//
//  Date+Extension.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 06.10.2022.
//

import Foundation

extension Date {
    static var dateFormatter = DateFormatter()
    
    static func getDate(from timeInterval: Double) -> Date {
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    func dateString(in format: String = "dd MMMM") -> String {
        let formatter = Date.dateFormatter
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
