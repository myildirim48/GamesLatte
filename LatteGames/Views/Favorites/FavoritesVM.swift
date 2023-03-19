//
//  FavoritesVM.swift
//  LatteGames
//
//  Created by YILDIRIM on 27.02.2023.
//

import UIKit
import CoreData

class FavoriteVM: NSObject {
    
    enum ChangeType { case insert,remove }
    
    private let environment: Environment
    private var dataSource: GamesDataSource?
    private var favoriteGames: [DisplayableResource]?
    private var favoriteGamesController: FavoriteGamesFetchController!
    
    init(environemnt: Environment) {
        self.environment = environemnt
        super.init()
        
        favoriteGamesController = FavoriteGamesFetchController(context: environemnt.store.viewContext, delegate: self)
        favoriteGamesController.updateFetchController()
        favoriteGames = favoriteGamesController.fetchedResultsController.fetchedObjects?.toDisplayableResource()
    }
    
    //MARK: -  DataSource
    func configureDataSource(with dataSource: GamesDataSource) {
        self.dataSource = dataSource
        configureDataSource()
    }
    
    func item(for indexPath: IndexPath) -> DisplayableResource? {
        let game =  dataSource?.itemIdentifier(for: indexPath)
        return game
    }
    
    private func configureDataSource() {
        var initialSnapshot = GamesSnapshot()
        initialSnapshot.appendSections([.alltimeBest])
        initialSnapshot.appendItems(favoriteGames ?? [], toSection: .alltimeBest)
        apply(initialSnapshot, animating: false)
    }
    private func updateDataSource(with type: ChangeType, game: DisplayableResource) {
        guard let dataSource = dataSource else { return }
        
        var updateSnapshot = dataSource.snapshot()
        switch type {
        case .insert:
            guard !updateSnapshot.itemIdentifiers.contains(game) else { return }
            updateSnapshot.appendItems([game], toSection: .alltimeBest)
        case .remove:
            guard updateSnapshot.itemIdentifiers.contains(game) else { return }
            updateSnapshot.deleteItems([game])
        }
        apply(updateSnapshot)
    }
    
    private func apply(_ changes: GamesSnapshot, animating: Bool = true) {
        DispatchQueue.global().async {
            self.dataSource?.apply(changes, animatingDifferences: animating)
        }
    }
}
//MARK: - NSFetchedResultsControllerDelegate
extension FavoriteVM: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith diff: CollectionDifference<NSManagedObjectID>) {
        for change in diff {
            switch change {
            case .insert(_, let elementId, _):
                if let gameObject = environment.store.viewContext.registeredObject(for: elementId) as? GameObject {
                    let game = DisplayableResource(managedObject: gameObject)
                    updateDataSource(with: .insert, game: game)
                }
            case .remove(_, let elementId, _):
                if let gameObject = environment.store.viewContext.registeredObject(for: elementId) as? GameObject {
                    let game = DisplayableResource(managedObject: gameObject)
                    updateDataSource(with: .remove, game: game)
                }
            }
        }
    }
}
