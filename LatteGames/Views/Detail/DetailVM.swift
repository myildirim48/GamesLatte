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
    

//    var selectedGameDetail: GameDetail?
    
    var gameDetailsVoid : ((GameDetail) -> Void)!

    let environment: Environment!
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
    
}

extension DetailVM: GameDetailRequestManagerDelegate {
    func gameDetailRequestManagerDidRecieveData(for GameDetail: GameDetail) {
        self.gameDetailsVoid(GameDetail)
    }
    
    func gameDetailRequestManagerDidRecieveError(userFriendlyError: UserFriendlyError) {
        delegate?.viewModelDidReceiveError(error: userFriendlyError)
    }
    
    
}
