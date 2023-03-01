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
    var gameRequestManager: GameRequestManager?

    weak var delegate: GamesViewModelDelegate?
    
    init(environment: Environment!) {
        self.environment = environment
        super.init()
        configure()
    }
    
    private func configure() {
        gameRequestManager = GameRequestManager(server: environment.server, delegate: self)
        gameRequestManager?.configureRequests()
        gameRequestManager?.requestAll()
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
    
}

extension GamesVM: GameRequestManagerDelegate {
    func requestManagerDidRecieveData(for section: GamesDataSource.Section, data: [DisplayableResource]) {
        applyDatasourceChange(section: section, resources: data)

    }
    
    func requestManagerDidReceiveError(userFriendlyError: UserFriendlyError) {
        delegate?.viewModelDidReceiveError(error: userFriendlyError)
    }
}
