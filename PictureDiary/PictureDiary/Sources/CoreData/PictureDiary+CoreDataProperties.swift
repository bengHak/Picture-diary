//
//  PictureDiary+CoreDataProperties.swift
//  
//
//  Created by 고병학 on 2022/08/18.
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
    @NSManaged public var didStamp: Bool
    @NSManaged public var drawing: Data?
    @NSManaged public var id: Int64
    @NSManaged public var imageUrl: String?
    @NSManaged public var isRandomDiary: Bool
    @NSManaged public var weather: Int16

}
