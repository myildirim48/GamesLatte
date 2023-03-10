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
    @NSManaged public var rating: Double
    @NSManaged public var id: Int64
    @NSManaged public var metacritic: Int64
    @NSManaged public var released: String?
    @NSManaged public var name: String?
    @NSManaged public var persistenceID: UUID?
    @NSManaged public var image: ImageObject?
    @NSManaged public var genres: NSSet?
        
    
    public static var defaultSortDescriptor: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "released", ascending: true)]
    }
    
    static func createGame(with game: GameDataModelResult, genres: GenreObject?, image: ImageObject, in context: NSManagedObjectContext) -> GameObject {
    
        let gameObject = GameObject(context: context)
        gameObject.released = game.released
        gameObject.id = Int64(game.id)
        gameObject.metacritic = Int64(game.metacritic)
        gameObject.name = game.name
        gameObject.image = image
        gameObject.rating = game.rating
        gameObject.released = game.released
        gameObject.suggestionCount = Int64(game.suggestionsCount)
        gameObject.genres = NSSet(array: game.genres ?? [])
        return gameObject
    }
    
    static func deleteGame(with game: GameDataModelResult, in context: NSManagedObjectContext) throws {
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
extension GameObject {
// MARK: Generated accessors for genres
    @objc(addGenresObject:)
    @NSManaged public func addToGenres(_ value: GenreObject)

    @objc(removeGenresObject:)
    @NSManaged public func removeFromGenres(_ value: GenreObject)

    @objc(addGenres:)
    @NSManaged public func addToGenres(_ values: NSSet)

    @objc(removeGenres:)
    @NSManaged public func removeFromGenres(_ values: NSSet)
}
