//
//  Movie+CoreDataClass.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 24.10.2022.
//
//

import Foundation
import CoreData

@objc(Movie)
public class Movie: NSManagedObject {
    
    convenience init() {
        self.init(context: CoreDataManager.shared.getContext())
    }
}
