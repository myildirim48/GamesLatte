//
//  GameModel.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
struct GameDataModelResult: Codable {
    
    enum GameModelType {
        case alltimeBest, metaCritic, alltimeBestMultiplayer, lastyearPopular, last30DaysReleased
    }
    
    let name: String?
    let released: String?
    let backgroundImage: String?
    let metacritic: Int?
    let id: Int?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case name,released,metacritic,id,genres
        case backgroundImage = "background_image"
    }
}
extension GameDataModelResult: Hashable, Equatable {
    
    static func == (lhs: GameDataModelResult, rhs: GameDataModelResult) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}

