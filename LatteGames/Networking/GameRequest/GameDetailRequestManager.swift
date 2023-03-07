//
//  GameDetailRequestManager.swift
//  LatteGames
//
//  Created by YILDIRIM on 3.03.2023.
//

import Foundation

protocol GameDetailRequestManagerDelegate: NSObject {
    func gameDetailRequestManagerDidRecieveData(for GameDetail: GameDetail)
    func gameDetailRequestManagerDidRecieveScreenShots(for ScreenShots: [ScreenshotResult])
    func gameDetailRequestManagerDidRecieveError(userFriendlyError: UserFriendlyError)
}

class GameDetailRequestManager {
    let server: Server!
    
    weak var delegate: GameDetailRequestManagerDelegate?
    
    var gameDetailRequest: GameRequest<GameDetail>!
    var gameScreenshotsRequest: GameRequest<NetworkResponse<ScreenshotResult>>!
    
    var gameDetailRequestLoader: RequestLoader<GameRequest<GameDetail>>!
    var gameScreenshotsRequestLoader: RequestLoader<GameRequest<NetworkResponse<ScreenshotResult>>>!

    init(server: Server!, delegate: GameDetailRequestManagerDelegate) {
        self.server = server
        self.delegate = delegate
    }
    
    func configureRequests(id:Int) {
        gameDetailRequest = try? server.fetchGameDetail(id: id)
        gameScreenshotsRequest = try? server.fetchGameScreenShots(id: id)
        
        gameDetailRequestLoader = RequestLoader(request: gameDetailRequest)
        gameScreenshotsRequestLoader = RequestLoader(request: gameScreenshotsRequest)
    }
    
    func fetchAllDetails(){
        fetchGameDetails()
    }
    
    private func fetchGameDetails() {
        
        gameDetailRequestLoader.load(data: []) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.delegate?.gameDetailRequestManagerDidRecieveData(for: success)
                }
                return
            case .failure(let error):
                self.delegate?.gameDetailRequestManagerDidRecieveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
        
        gameScreenshotsRequestLoader.load(data: []) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let response = response.results else { return }
                DispatchQueue.main.async {
                    self.delegate?.gameDetailRequestManagerDidRecieveScreenShots(for: response)
                    }
                return
            case . failure(let error):
                
                self.delegate?.gameDetailRequestManagerDidRecieveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
        
        
    }
}
