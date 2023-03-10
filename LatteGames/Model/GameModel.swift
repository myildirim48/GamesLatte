//
//  GameModel.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation


struct GameDataModelResult: Codable {

    let name: String
    let released: String?
    let backgroundImage: String?
    let metacritic: Int
    let id: Int
    let rating: Double
    let genres: [Genre]?
    let suggestionsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case name,released,metacritic,id,genres,rating
        case backgroundImage = "background_image"
        case suggestionsCount = "suggestions_count"
    }

}
extension GameDataModelResult: Hashable, Equatable, Displayable{
    func convert(type: GameModelType) -> DisplayableResource {
        return DisplayableResource(type: type, name: name, released: released, backgroundImage: backgroundImage, metacritic: metacritic, rating: rating, id: id, genres: genres, suggestionsCount: suggestionsCount)
    }
    
    
    static func == (lhs: GameDataModelResult, rhs: GameDataModelResult) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    

}


