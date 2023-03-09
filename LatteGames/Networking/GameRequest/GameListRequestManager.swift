//
//  GameRequestManager.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
protocol GameListRequestManagerDelegate:NSObject {
    func requestManagerDidRecieveData(for section: GamesDataSource.Section, data: [DisplayableResource],dataContainer: NetworkResponse<GameDataModelResult>)
    func requestManagerDidReceiveError(userFriendlyError: UserFriendlyError)
}
class GameListRequestManager {
    
    let server: Server!
    weak var delegate :GameListRequestManagerDelegate?
    
     private var gamesRequest : GameRequest<NetworkResponse<GameDataModelResult>>!
    
    private var gamesRequestLoader : RequestLoader<GameRequest<NetworkResponse<GameDataModelResult>>>!
    
    init(server: Server,delegate: GameListRequestManagerDelegate) {
        self.server = server
        self.delegate = delegate
    }

    func configureRequests() {
        gamesRequest = try? server.gameAllRequest()
        gamesRequestLoader = RequestLoader(request: gamesRequest)
    }
    
    func requestAll(){
        fetchAllTime()
        fetchMultiTags()
        fetchBetweenDates(dateFrom: "2022-01-01", dateTo: "2022-12-31", sectionFor: .lastyearPopular, displayableFor: .lastyearPopular)
        fetchBetweenDates(dateFrom: "2023-01-01", dateTo: Date().dateToString(dateFormat: "yyyy-MM-dd"), sectionFor: .lastmonthReleased, displayableFor: .last30DaysReleased)
    }
    
    func fetchAllTime(page:Int = 1){
        
        gamesRequestLoader.load(data: [.page(page: page.toString())]) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let results = response.results else { return }
                self.delegate?.requestManagerDidRecieveData(for: .alltimeBest, data: results.toDisplayable(type: .alltimeBest), dataContainer: response)
                return
            case .failure(let error):
                self.delegate?.requestManagerDidReceiveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
    }
    
    func fetchMultiTags(page:Int = 1){
        let multiQuery : [Query] = [.tags("multiplayer"),
                                    .ordering("ratings_count"),
                                    .page(page: page.toString())]
        gamesRequestLoader.load(data: multiQuery) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let results = response.results else { return }
                self.delegate?.requestManagerDidRecieveData(for: .alltimeBestMultiplayer, data: results.toDisplayable(type: .alltimeBestMultiplayer), dataContainer: response)
                return
            case .failure(let error):
                self.delegate?.requestManagerDidReceiveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
    }
    
    func fetchBetweenDates(dateFrom: String, dateTo:String, sectionFor: GamesDataSource.Section, displayableFor: GameModelType,page: Int = 1) {
        let datesQuery : [Query] = [.ordering("rating_counts"),
                                    .dates(betweenDates: dateFrom, dateTo),
                                    .page(page: page.toString())]
        
        gamesRequestLoader.load(data: datesQuery) { [weak self] result in
            switch result {
            case .success(let response):
                guard let results = response.results else { return }
                self?.delegate?.requestManagerDidRecieveData(for: sectionFor, data: results.toDisplayable(type: displayableFor), dataContainer: response)
                return
            case .failure(let error):
                self?.delegate?.requestManagerDidReceiveError(userFriendlyError: .userFriendlyError(error))
                return
            }
        }
    }
}
