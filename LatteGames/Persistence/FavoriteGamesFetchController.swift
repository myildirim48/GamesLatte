//
//  FavoriteGamesFetchController.swift
//  LatteGames
//
//  Created by YILDIRIM on 10.03.2023.
//

import UIKit
import CoreData

final class FavoriteGamesFetchController: NSObject {
    
    private var context: NSManagedObjectContext!
    weak var delegate: NSFetchedResultsControllerDelegate?
    
    init(context: NSManagedObjectContext, delegate: NSFetchedResultsControllerDelegate){
        self.context = context
        self.delegate = delegate
        super.init()
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<GameObject> = {
        let request: NSFetchRequest<GameObject> = GameObject.fetchRequest()
        request.sortDescriptors = GameObject.defaultSortDescriptor
        request.relationshipKeyPathsForPrefetching = ["image","genres"]
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 0

        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = delegate
        
        return controller
    }()
    
    func updateFetchController() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
