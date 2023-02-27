//
//  DataSource+Snapshots.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import UIKit

typealias GamesSnapshot = NSDiffableDataSourceSnapshot<GamesDataSource.Section, [GameDataModelResult]>

class GamesDataSource: UICollectionViewDiffableDataSource<GamesDataSource.Section, [GameDataModelResult]> {
    
    enum Section:CaseIterable {
        case alltimeBest, metaCritic, alltimeBestMultiplayer, lastyearPopular, last30DaysReleased
    }
    
}
