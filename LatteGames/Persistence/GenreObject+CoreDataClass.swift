//
//  GenreObject+CoreDataClass.swift
//  LatteGames
//
//  Created by YILDIRIM on 10.03.2023.
//
//

import Foundation
import CoreData

@objc(GenreObject)
public class GenreObject: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GenreObject> {
        return NSFetchRequest<GenreObject>(entityName: "GenreObject")
    }

    @NSManaged public var name: String?
    @NSManaged public var genres: GameObject?
}
