//
//  String+Extensions.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 06.10.2022.
//

import Foundation

extension String {
    func dateFromString(with format: String) -> Date? {
        let dateFormatter = Date.dateFormatter
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
