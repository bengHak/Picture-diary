//
//  PictureDiary+CoreDataProperties.swift
//  
//
//  Created by byunghak on 2022/05/10.
//
//

import Foundation
import CoreData


extension PictureDiary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PictureDiary> {
        return NSFetchRequest<PictureDiary>(entityName: "PictureDiary")
    }
    
    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var drawing: Data?
    @NSManaged public var weather: Int16

}
