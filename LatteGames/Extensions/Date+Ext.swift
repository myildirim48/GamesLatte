//
//  Date+Ext.swift
//  LatteGames
//
//  Created by YILDIRIM on 1.03.2023.
//

import Foundation
//"dd.MM.yyyy"
extension Date {
    func dateToString(dateFormat: String = "dd.MM.yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
