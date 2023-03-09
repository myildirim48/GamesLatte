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
    private enum State { case ready, loading }
    
    private let environment: Environment!
    private var state: State = .ready
    
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
    
    func item(for indexPath: IndexPath) -> Int? {
        dataSource.itemIdentifier(for: indexPath)?.id
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
    private let defaultPrefetchBuffer = 1
//    
//    private var requestOffset: Int {
//        guard let co = dataContainer else {
//            return 0
//        }
//        let newOffset = co.offset + defaultPageSize
//        return newOffset >= co.total ? co.offset : newOffset
//    }
//    private var hasNextPage: Bool {
//        guard let co = dataContainer else {
//            return true
//        }
//        let newOffset = co.offset + defaultPageSize
//        return newOffset >= co.total ? false : true
//    }
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
