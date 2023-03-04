//
//  GameDetailRequestManager.swift
//  LatteGames
//
//  Created by YILDIRIM on 3.03.2023.
//

import Foundation

protocol GameDetailRequestManagerDelegate: NSObject {
    func gameDetailRequestManagerDidRecieveData(for GameDetail: GameDetail)
    func gameDetailRequestManagerDidRecieveError(userFriendlyError: UserFriendlyError)
}

class GameDetailRequestManager {
    let server: Server!
    
    weak var delegate: GameDetailRequestManagerDelegate?
    
    var gameDetailRequest: GameRequest<GameDetail>!
    
    var gameDetailRequestLoader: RequestLoader<GameRequest<GameDetail>>!
    
    init(server: Server!, delegate: GameDetailRequestManagerDelegate) {
        self.server = server
        self.delegate = delegate
    }
    
    func configureRequests(id:Int) {
        gameDetailRequest = try? server.fetchGameDetail(id: id)
        
        gameDetailRequestLoader = RequestLoader(request: gameDetailRequest)
    }
    
    func fetchAllDetails(){
        fetchGameDetails()
    }
    
    private func fetchGameDetails() {
        
        gameDetailRequestLoader.load(data: []) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                print(success)
                DispatchQueue.main.async {
                    self.delegate?.gameDetailRequestManagerDidRecieveData(for: success)
                }

                return
            case .failure(let error):
                self.delegate?.gameDetailRequestManagerDidRecieveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
        
//        gameDetailRequestLoader.load(data: []) { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let response):
//                guard let response = response.results else { return }
//                self?.delegate?.gameDetailRequestManagerDidRecieveData(for: response)
//            case .failure(let error):
//                self.delegate?.gameDetailRequestManagerDidRecieveError(userFriendlyError: .userFriendlyError(error))
//            }
//        }
    }
}
