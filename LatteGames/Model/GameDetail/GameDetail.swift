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
    let backgroundImage: String?
    let rating: Double?
    let ratings: [Ratings]?
    let playtime: Int
    
    enum CodingKeys: String, CodingKey {
        case name,metacritic,released,website,publishers,genres,id,rating,ratings,playtime
        case descriptionRaw = "description_raw"
        case parentPlatforms = "parent_platforms"
        case backgroundImage = "background_image"
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
    
    var name: String?
}

struct Ratings: Codable {
    let title: Title?
    let percent: Double?
}

enum Title: String, Codable {
    case exceptional = "exceptional"
    case meh = "meh"
    case recommended = "recommended"
    case skip = "skip"
}
