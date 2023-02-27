//
//  Array+Ext.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
extension Array where Element == Query {
    func toItems() -> Array<URLQueryItem>?{
        self.isEmpty ? nil : self.map({ $0.item() })
    }
}
