//
//  ScreenShots.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation

// MARK: - Result
struct ScreenshotResult: Codable,Hashable {
    let id: Int
    let image: String

    enum CodingKeys: String, CodingKey {
        case id, image
    }
}
