//
//  CoreDataManager.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.10.2022.
//

import Foundation
import CoreData

protocol CoreDataManager {
    func fetch<T: NSManagedObject>(_ object: T.Type,
                                    predicate: NSPredicate?,
                                    sortDescriptors: [NSSortDescriptor]?,
                                    completion: @escaping DataBlock<T>)
    func save(_ object: DataObject)
    func getContext() -> NSManagedObjectContext
}

final class DefaultCoreDataManager: CoreDataManager {
    // MARK: - Properties
    static let shared = DefaultCoreDataManager()
    private let containerName = "MovieData"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    // MARK: - Life Cycle Methods
    private init() {}
    
    // MARK: - Internal Methods
    func fetch<T: NSManagedObject>(_ object: T.Type,
                                   predicate: NSPredicate? = nil,
                                   sortDescriptors: [NSSortDescriptor]? = nil,
                                   completion: @escaping DataBlock<T>) {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        do {
            let data = try context.fetch(request)
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
    
    func save(_ object: DataObject) {
        object.add()
        saveContext()
    }
    
    func getContext() -> NSManagedObjectContext {
        return context
    }
    
    // MARK: - Private Methods
    private func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
