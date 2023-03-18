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
    
 
    func deleteCharacter(game:DisplayableResource ) {
        let context = backgroundContext
        
        context.perform {
            do {
                try GameObject.deleteGame(with: game, in: context)
            self.save(context) { result in
                    switch result {
                    case .success(let status): print("Save status: \(status)")
                    case .failure(let errorStatus): self.storeErrors?.append(errorStatus)
                    }
                }
            }catch {
                let storeError = StoreError.save(error)
                self.storeErrors?.append(storeError)
            }
        }
    }
    
    func toggleStorage(for game: DisplayableResource, with data: Data? = nil, completion: @escaping (Bool) -> Void) {
        let context = viewContext
        context.perform {
            do {
                if  context.hasPersistenceId(for: game) {
                    try GameObject.deleteGame(with: game, in: context)
                    print("Deleted")
                }
                else {
                    if let imageData = data{
                        _ = GameObject.createGame(with: game, imgData: imageData, in: context)
                        print("Saved with imgdata")
                    } else {
                        _ = GameObject.createGame(with: game, imgData: nil, in: context)
                        print("Saved without imgdata")
                    }
                }
                
                self.save(context) { result in
                    switch result {
                    case .success(_): completion(true)
                        print("Succes")
                    case .failure(let storeError):
                        completion(false)
                        self.storeErrors?.append(storeError)
                    }
                }
            }catch {
                let storeError = StoreError.save(error)
                self.storeErrors?.append(storeError)
                completion(false)
            }
        }
    }
    
    private func save(_ context: NSManagedObjectContext, completion: @escaping (Result<Bool, StoreError>) -> ()) {
        var status = false
        context.perform {
            if context.hasChanges{
                do {
                    try context.save()
                }catch{
                    let error = StoreError.save(error)
                    return completion(.failure(error))
                }
            }
            status = true
            completion(.success(status))
        }
    }
}
extension NSManagedObjectContext {
    func hasPersistenceId(for character: DisplayableResource) -> Bool{
        let request: NSFetchRequest<GameObject> = GameObject.fetchRequest()
        request.predicate = NSPredicate(format: "id = %ld", Int64(character.id))
        request.propertiesToFetch = ["id"]
        do {
            let match = try self.fetch(request)
            guard let _ = match.first else {
                return false
            }
            return true
        }catch {
            return false
        }
    }
}
