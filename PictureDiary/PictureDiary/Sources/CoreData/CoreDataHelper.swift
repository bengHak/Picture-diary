//
//  CoreDataHelper.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/28.
//

import CoreData
import UIKit

class CoreDataHelper {
    static let shared = CoreDataHelper()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName = "PictureDiary"
    
    func getDiary() -> [PictureDiary] {
        var models: [PictureDiary] = []
        
        guard let context = context else { return [] }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: modelName)
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        if let fetchResult = try? context.fetch(fetchRequest) as? [PictureDiary] {
            models = fetchResult
        } else {
            print("🔴 Could not fetch")
        }
        
        return models
        
    }
    
    func saveDiary(
        date: Date,
        weather: WeatherType,
        drawing: Data?,
        content: String,
        completionHandler: @escaping ((Bool) -> Void)
    ) {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: modelName, in: context)  else {
            completionHandler(false)
            return
        }
        
        if let diary = NSManagedObject(entity: entity, insertInto: context) as? PictureDiary {
            diary.date = date
            diary.weather = weather.rawValue
            diary.drawing = drawing
            diary.content = content
            
            do {
                try context.save()
                completionHandler(true)
            } catch let error as NSError {
                print("🔴 Could not save: \(error)")
                completionHandler(false)
            }
        }
        
    }
}
