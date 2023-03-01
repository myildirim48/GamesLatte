//
//  Date+Ext.swift
//  LatteGames
//
//  Created by YILDIRIM on 1.03.2023.
//

import Foundation
extension Date {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}
