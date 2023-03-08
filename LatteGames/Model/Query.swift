//
//  Query.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
struct Query:Equatable,Hashable {
    let name: String
    let value: String
}

extension Query {
    func item() -> URLQueryItem {
        URLQueryItem(name: name, value: value)
    }
    static func ordering(_ value: String) -> Query {
        Query(name: "ordering", value: value)
    }
    
    static func apikey(_ value: String = SecretKey.key) -> Query {
        Query(name: "key", value: value)
    }
    
    static func tags(_ value: String) -> Query {
        Query(name: "tags", value: value)
    }

    static func search(_ value: String) -> Query {
        Query(name: "search_exact", value: value)
    }
    
    static func dates(betweenDates dateFrom: String, _ dateTo: String) -> Query{
        Query(name: "dates", value: dateFrom + "," + dateTo)
    }
    static func page(page:String) -> Query {
        Query(name: "page", value: page)
    }
}
