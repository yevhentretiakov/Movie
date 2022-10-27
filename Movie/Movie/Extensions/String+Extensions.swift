//
//  String+Extensions.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 06.10.2022.
//

import Foundation

extension String {
    static let empty = ""
    
    func dateFromString() -> Date? {
        let dateFormatter = Date.isoDateFormatter
        dateFormatter.formatOptions = [
            .withFullDate
        ]
        return dateFormatter.date(from: self)
    }
    
    func formatDateString(with format: String = "dd MMMM") -> String? {
        return self.dateFromString()?.dateString(with: format)
    }
}
