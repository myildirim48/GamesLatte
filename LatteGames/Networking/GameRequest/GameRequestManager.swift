//
//  GameRequestManager.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
protocol GameRequestManagerDelegate:NSObject {
    func requestManagerDidRecieveData(for section: GamesDataSource.Section, data: [DisplayableResource])
    func requestManagerDidReceiveError(userFriendlyError: UserFriendlyError)
}
class GameRequestManager {
    
    let server: Server!
    weak var delegate :GameRequestManagerDelegate?
    
    var alltimeRequest : GameRequest<GameDataModelResult>!
    var multiplayerRequest : GameRequest<GameDataModelResult>!
    
    var alltimeRequestLoader : RequestLoader<GameRequest<GameDataModelResult>>!
    var multiplayerRequestLoader : RequestLoader<GameRequest<GameDataModelResult>>!
    
    
    init(server: Server,delegate: GameRequestManagerDelegate) {
        self.server = server
        self.delegate = delegate
    }

    func configureRequests() {
        alltimeRequest = try? server.gameAllRequest()
        multiplayerRequest = try? server.gameAllRequest()
        
        alltimeRequestLoader = RequestLoader(request: alltimeRequest)
        multiplayerRequestLoader = RequestLoader(request: multiplayerRequest)
        
    }
    
    func requestAll(){
        fetchAllTime()
        fetchMultiTags()
    }
    
    private func fetchAllTime(){
        alltimeRequestLoader.load(data: []) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.delegate?.requestManagerDidRecieveData(for: .alltimeBest, data: response.results.toDisplayable(type: .alltimeBest))
                print(response.results.toDisplayable(type: .alltimeBest))
                return
            case .failure(let error):
                self.delegate?.requestManagerDidReceiveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
    }
    
    private func fetchMultiTags(){
        let multiQuery : [Query] = [.tags("multiplayer")]
        multiplayerRequestLoader.load(data: multiQuery) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                
                self.delegate?.requestManagerDidRecieveData(for: .alltimeBestMultiplayer, data: response.results.toDisplayable(type: .alltimeBestMultiplayer))
                print(response.results.toDisplayable(type: .alltimeBestMultiplayer))
                return
            case .failure(let error):
                self.delegate?.requestManagerDidReceiveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
    }
}
