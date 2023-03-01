//
//  String+Ext.swift
//  LatteGames
//
//  Created by YILDIRIM on 1.03.2023.
//

import Foundation
extension String {
    func transformStringToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: self)
        dateFormatter.string(from: date!)
        return date ?? .now
    }
}
