//
//  Store.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import CoreData

class Store {
    enum StoreError:Error {
        case save(Error)
        case load(Error)
        case delete(Error)
    }
    
    private let container: NSPersistentContainer
    private var storeErrors: [StoreError]?
    
    init(name:String? = "LatteGames") {
        container = NSPersistentContainer(name: name!)
        container.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError("Unable to load store error : \(StoreError.load(error!))")
            }
        }
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        context.undoManager = nil
        return context
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        let context = container.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        context.undoManager = nil
        return context
    }()
    
 
    
}
