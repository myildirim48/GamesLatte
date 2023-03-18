//
//  DisplayableResource.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
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
}

extension DisplayableResource:Hashable {
    static func == (lhs: DisplayableResource, rhs: DisplayableResource) -> Bool {
        lhs.type == rhs.type && lhs.id == rhs.id
    }
}
