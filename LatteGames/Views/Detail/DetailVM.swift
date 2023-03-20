//
//  DetailVM.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
protocol DetailViewModelDelegate: NSObject{
    func viewModelDidReceiveError(error: UserFriendlyError)
//    func viewModelDidTogglePersistence(with status: Bool)
}

class DetailVM: NSObject {
    
    var gameDetailsVoid : ((GameDetail) -> Void)!
    var screenShotsVoid : (([ScreenshotResult]) -> Void)!
    
    let environment: Environment!
    
    var dataSource: GamesImagesDataSource!
    var detailViewRequestManager: GameDetailRequestManager?
    
    weak var delegate: DetailViewModelDelegate?
    
    init(environment: Environment!) {
        self.environment = environment
        super.init()
    }
    
    func configure(gameID: Int){
        detailViewRequestManager = GameDetailRequestManager(server: environment.server, delegate: self)
        detailViewRequestManager?.configureRequests(id: gameID)
        detailViewRequestManager?.fetchAllDetails()
    }
   
    func applyDatasourChange(resource: [ScreenshotResult]){
        guard !resource.isEmpty else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(GamesImagesDataSource.Section.allCases)
        snapshot.appendItems(resource,toSection: .main)
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }

}

extension DetailVM: GameDetailRequestManagerDelegate {
    func gameDetailRequestManagerDidRecieveScreenShots(for ScreenShots: [ScreenshotResult]) {
//        self.screenShotsVoid(ScreenShots) 
        applyDatasourChange(resource: ScreenShots)
    }
    
    func gameDetailRequestManagerDidRecieveData(for GameDetail: GameDetail) {
        self.gameDetailsVoid(GameDetail)
    }
    func gameDetailRequestManagerDidRecieveError(userFriendlyError: UserFriendlyError) {
        delegate?.viewModelDidReceiveError(error: userFriendlyError)
    }
    
    
}
