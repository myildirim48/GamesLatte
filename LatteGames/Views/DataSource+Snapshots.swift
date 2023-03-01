//
//  DataSource+Snapshots.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import UIKit

typealias GamesSnapshot = NSDiffableDataSourceSnapshot<GamesDataSource.Section, DisplayableResource>

class GamesDataSource: UICollectionViewDiffableDataSource<GamesDataSource.Section, DisplayableResource> {
    
    enum Section:CaseIterable {
        case alltimeBest, alltimeBestMultiplayer,lastyearPopular,lastmonthReleased
    }
    
}
