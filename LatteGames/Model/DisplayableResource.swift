//
//  DisplayableResource.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
import CoreData

protocol Persistable {
    associatedtype ManagedObject: NSManagedObject
    init(managedObject: ManagedObject)
}

protocol Displayable {
    func convert(type: GameModelType) -> DisplayableResource
}

enum GameModelType:Codable {
    case alltimeBest, metaCritic, alltimeBestMultiplayer, lastyearPopular, last30DaysReleased
}

struct DisplayableResource {
 
    
    let type : GameModelType
    let name: String?
    let released: String?
    let backgroundImage: String?
    let metacritic: Int?
    let rating: Double?
    let id: Int
    let genres: [Genre]?
    let suggestionsCount: Int?
    
    var imageData: Data?
}

extension DisplayableResource:Hashable {
    static func == (lhs: DisplayableResource, rhs: DisplayableResource) -> Bool {
        lhs.type == rhs.type && lhs.id == rhs.id
    }
}

extension DisplayableResource: Persistable{
    typealias ManagedObject = GameObject
    
    init(managedObject: GameObject) {
        type = GameModelType.alltimeBest
        id = Int(managedObject.id)
        name = managedObject.name
        released = managedObject.released
        imageData = managedObject.backgroundImage
        backgroundImage = ""
        metacritic = Int(managedObject.metacritic)
        rating = managedObject.rating
        genres = managedObject.genres?.toGenresArray()
        suggestionsCount = Int(managedObject.suggestionCount)
    }
}
