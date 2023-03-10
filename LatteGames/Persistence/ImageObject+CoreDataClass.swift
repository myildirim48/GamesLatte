//
//  ImageObject+CoreDataClass.swift
//  LatteGames
//
//  Created by YILDIRIM on 10.03.2023.
//
//

import Foundation
import CoreData

@objc(ImageObject)
public class ImageObject: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageObject> {
        return NSFetchRequest<ImageObject>(entityName: "ImageObject")
    }

    @NSManaged public var imgData: Data?
    @NSManaged public var path: String?
    @NSManaged public var gameObject: GameObject?

    
    static func findOrCreateImage(with path: String?, with data: Data?, in context: NSManagedObjectContext) throws -> ImageObject {
        let request: NSFetchRequest<ImageObject> = ImageObject.fetchRequest()
        request.predicate = NSPredicate(format: "path = %@", path!)
        
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                return match.first!
            }
        } catch {
            throw error
        }
        
        let imageObject = ImageObject(context: context)
        imageObject.path = path
        imageObject.imgData = data
        return imageObject
    }
}
