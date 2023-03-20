//
//  GamesVM.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import Foundation
protocol GamesViewModelDelegate: NSObject {
    func viewModelDidReceiveError(error: UserFriendlyError)
}

class GamesVM: NSObject {
    
    private let environment: Environment!
    
    var dataSource: GamesDataSource! = nil
    var gameRequestManager: GameListRequestManager?
    var gamesDataContainer: NetworkResponse<GameDataModelResult>?

    weak var errorHandler: GamesViewModelDelegate?
    
    init(environment: Environment!) {
        self.environment = environment
        super.init()
        configure()
    }
    
    private func configure() {
        gameRequestManager = GameListRequestManager(server: environment.server, delegate: self)
        gameRequestManager?.configureRequests()
        gameRequestManager?.requestAll()
    }
    
    func item(for indexPath: IndexPath) -> DisplayableResource? {
        dataSource.itemIdentifier(for: indexPath)
    }
    
    func applyDatasourceChange(section: GamesDataSource.Section, resources: [DisplayableResource]){
        guard !resources.isEmpty else { return }
        
        var snapshot = dataSource.snapshot()
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections(GamesDataSource.Section.allCases)
        }
        snapshot.appendItems(resources,toSection: section)
        dataSource.apply(snapshot,animatingDifferences: false)
    }
    // MARK: - Pagination
    private let defaultPageSize = 20
    private var currentPage = 1
    private var totalPages = 0
    
    private var hasNextPage: Bool {
        guard let co = gamesDataContainer else {
            return true
        }
        
        if co.count % 20 == 0 {
            totalPages = co.count  / 20
            
        }else {
            totalPages = (co.count / 20) + 1
        }
        
        currentPage += 1
        return currentPage >= totalPages ? false : true
    }
    
    func pagination(section: GamesDataSource.Section,index: Int){
        
        if hasNextPage && index == dataSource.snapshot().numberOfItems(inSection: section)-1 {
            
            switch section {
            case .alltimeBest:
                gameRequestManager?.fetchAllTime(page: currentPage)
            case .alltimeBestMultiplayer:
                gameRequestManager?.fetchMultiTags(page : currentPage)
            case .lastyearPopular:
                gameRequestManager?.fetchBetweenDates(dateFrom: "2022-01-01", dateTo: "2022-12-31", sectionFor: .lastyearPopular, displayableFor: .lastyearPopular, page: currentPage)
            case .lastmonthReleased:
                gameRequestManager?.fetchBetweenDates(dateFrom: (Date()-30).dateToString(dateFormat: "yyyy-MM-dd"), dateTo: Date().dateToString(dateFormat: "yyyy-MM-dd"), sectionFor: .lastmonthReleased, displayableFor: .last30DaysReleased,page: currentPage)
            }
        }

    }
    
}

extension GamesVM: GameListRequestManagerDelegate {
    func requestManagerDidRecieveData(for section: GamesDataSource.Section, data: [DisplayableResource], dataContainer: NetworkResponse<GameDataModelResult>) {
        applyDatasourceChange(section: section, resources: data)
        gamesDataContainer = dataContainer
    }
    
    func requestManagerDidReceiveError(userFriendlyError: UserFriendlyError) {
        errorHandler?.viewModelDidReceiveError(error: userFriendlyError)
    }
}
