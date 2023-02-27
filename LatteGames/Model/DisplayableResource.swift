//
//  DisplayableResource.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
protocol Displayable {
    func convert(type: Self) -> DisplayableResource
}

struct DisplayableResource {
    
    enum GameModelType {
        case alltimeBest, metaCritic, alltimeBestMultiplayer, lastyearPopular, last30DaysReleased
    }
    #warning("????????")
    
    let type : GameModelType
    let name: String?
    let released: String?
    let backgroundImage: String?
    let metacritic: Int?
    let id: Int
    let genres: [Genre]?
}

extension DisplayableResource:Hashable {
    static func == (lhs: DisplayableResource, rhs: DisplayableResource) -> Bool {
        lhs.type == rhs.type && lhs.id == rhs.id
    }
}
