//
//  NetworkResponse.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation

struct NetworkResponse<T: Codable>: Codable {
    let count: Int
    let results: [T]?
    let detail: String?
}
