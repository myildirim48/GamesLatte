//
//  GameObject+CoreDataClass.swift
//  LatteGames
//
//  Created by YILDIRIM on 10.03.2023.
//
//

import Foundation
import CoreData

@objc(GameObject)
public class GameObject: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameObject> {
        return NSFetchRequest<GameObject>(entityName: "GameObject")
    }
    
    @NSManaged public var suggestionCount: Int64
    @NSManaged public var id: Int64
    @NSManaged public var metacritic: Int64
    @NSManaged public var released: String?
    @NSManaged public var name: String
    @NSManaged public var persistenceID: UUID
    @NSManaged public var backgroundImage: Data?
    @NSManaged public var genres: String?
    @NSManaged public var rating: Double
        
    
    public static var defaultSortDescriptor: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "released", ascending: true)]
    }
    
    static func createGame(with game: DisplayableResource, imgData: Data?, in context: NSManagedObjectContext) -> GameObject {
    
        let gameObject = GameObject(context: context)
        gameObject.released = game.released
        gameObject.id = Int64(game.id)
        gameObject.metacritic = Int64(game.metacritic ?? 0)
        gameObject.name = game.name ?? ""
        gameObject.backgroundImage = imgData
        gameObject.rating = game.rating ?? 0.0
        gameObject.released = game.released
        gameObject.suggestionCount = Int64(game.suggestionsCount ?? 0)
        gameObject.genres = game.genres?.map{ $0.name ?? ""}.joined(separator: ", ")
                                             
        return gameObject
    }
    
    static func deleteGame(with game: DisplayableResource, in context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<GameObject> = GameObject.fetchRequest()
        request.predicate = NSPredicate(format: "id = %ld", Int64(game.id))
        
        do {
            let match = try context.fetch(request)
            guard let persistedCharacter = match.first else {
                return
            }
            context.delete(persistedCharacter)
        } catch {
            throw error
        }
    }
    
}

