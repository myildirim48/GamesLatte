//
//  GameDetail.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation

struct GameDetail: Codable {
    let id : Int
    let name : String
    let descriptionRaw: String
    let metacritic : Int
    let released: String
    let website: String
    let publishers: [Publisher]
    let genres: [Genre]
    let parentPlatforms: [ParentPlatform]
    
    enum CodingKeys: String, CodingKey {
        case name,metacritic,released,website,publishers,genres,id
        case descriptionRaw = "description_raw"
        case parentPlatforms = "parent_platforms"
    }
}
struct ParentPlatform: Codable {
    let platform: Publisher
}

struct Publisher: Codable {
    let id: Int
    let name: String
}


struct Genre: Codable,Hashable {
    
    var id: Int?
    var name: String?
}
