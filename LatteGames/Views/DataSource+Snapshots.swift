//
//  DataSource+Snapshots.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import UIKit

typealias SearchSnapshot = NSDiffableDataSourceSnapshot<SearchDataSource.Section, GameDataModelResult>

class SearchDataSource: UICollectionViewDiffableDataSource<SearchDataSource.Section, GameDataModelResult> {
    
    enum Section:CaseIterable {
        case main
    }
    
}



typealias GamesSnapshot = NSDiffableDataSourceSnapshot<GamesDataSource.Section, DisplayableResource>

class GamesDataSource: UICollectionViewDiffableDataSource<GamesDataSource.Section, DisplayableResource> {
    
    enum Section:CaseIterable {
        case alltimeBest, alltimeBestMultiplayer,lastyearPopular,lastmonthReleased
    }
    
}

typealias GamesImagesSnapShot = NSDiffableDataSourceSnapshot<GamesImagesDataSource.Section, ScreenshotResult>

class GamesImagesDataSource: UICollectionViewDiffableDataSource<GamesImagesDataSource.Section, ScreenshotResult> {
    
    enum Section:CaseIterable{
        case main
    }
}
