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
    
    /// 그림 이미지 데이터
    @NSManaged public var drawing: Data?
    @NSManaged public var imageUrl: String?
    @NSManaged public var weather: Int16
    @NSManaged public var id: Int
}

extension PictureDiary {
    func getWeather() -> WeatherType {
        return WeatherType.init(rawValue: self.weather)!
    }
}
