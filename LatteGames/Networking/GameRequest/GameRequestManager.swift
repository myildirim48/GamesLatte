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
    
    var gamesRequest : GameRequest<GameDataModelResult>!
//    var multiplayerRequest : GameRequest<GameDataModelResult>!
    
    var gamesRequestLoader : RequestLoader<GameRequest<GameDataModelResult>>!
//    var multiplayerRequestLoader : RequestLoader<GameRequest<GameDataModelResult>>!
    
    
    init(server: Server,delegate: GameRequestManagerDelegate) {
        self.server = server
        self.delegate = delegate
    }

    func configureRequests() {
        gamesRequest = try? server.gameAllRequest()
//        multiplayerRequest = try? server.gameAllRequest()
        gamesRequestLoader = RequestLoader(request: gamesRequest)
//        multiplayerRequestLoader = RequestLoader(request: multiplayerRequest)
    }
    
    func requestAll(){
        fetchAllTime()
        fetchMultiTags()
        fetchBetweenDates(dateFrom: "2022-01-01", dateTo: "2022-12-31", sectionFor: .lastyearPopular, displayableFor: .lastyearPopular)
        fetchBetweenDates(dateFrom: "2023-01-01", dateTo: Date().dateToString(dateFormat: "yyyy-MM-dd"), sectionFor: .lastmonthReleased, displayableFor: .last30DaysReleased)
    }
    
    private func fetchAllTime(){
        gamesRequestLoader.load(data: []) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.delegate?.requestManagerDidRecieveData(for: .alltimeBest, data: response.results.toDisplayable(type: .alltimeBest))
                return
            case .failure(let error):
                self.delegate?.requestManagerDidReceiveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
    }
    
    private func fetchMultiTags(){
        let multiQuery : [Query] = [.tags("multiplayer"),
                                    .ordering("ratings_count")]
        gamesRequestLoader.load(data: multiQuery) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                
                self.delegate?.requestManagerDidRecieveData(for: .alltimeBestMultiplayer, data: response.results.toDisplayable(type: .alltimeBestMultiplayer))
                return
            case .failure(let error):
                self.delegate?.requestManagerDidReceiveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
    }
    
    private func fetchBetweenDates(dateFrom: String, dateTo:String, sectionFor: GamesDataSource.Section, displayableFor: GameModelType) {
        let datesQuery : [Query] = [.ordering("rating_counts"),
                                    .dates(betweenDates: dateFrom, dateTo)]
        gamesRequestLoader.load(data: datesQuery) { [weak self] result in
            switch result {
            case .success(let response):
                self?.delegate?.requestManagerDidRecieveData(for: sectionFor, data: response.results.toDisplayable(type: displayableFor))
                return
            case .failure(let error):
                self?.delegate?.requestManagerDidReceiveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
    }
}
