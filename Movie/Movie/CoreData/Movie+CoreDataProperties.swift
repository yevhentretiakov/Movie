//
//  Movie+CoreDataProperties.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 24.10.2022.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var backdropPath: String?
    @NSManaged public var genres: [String]?
    @NSManaged public var id: Int64
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double

}

extension Movie : Identifiable {

}
