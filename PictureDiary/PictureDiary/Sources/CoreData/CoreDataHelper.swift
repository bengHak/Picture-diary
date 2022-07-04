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
    
    private var cached: [PictureDiary]
    
    init() {
        self.cached = []
    }
    
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
    
    func getDiaryById(_ id: Int) -> PictureDiary? {
        let filtered = cached.filter { $0.id == id }
        if filtered.count == 1 {
            return filtered.first
        }
        
        guard let context = context else { return nil }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: modelName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
        
        if let fetchResult = try? context.fetch(fetchRequest) as? [PictureDiary],
           fetchResult.count == 1 {
            cached.append(fetchResult.first!)
            return fetchResult.first!
        } else {
            print("🔴 Could not fetch")
            return nil
        }
    }
    
    func saveDiary(
        id: Int,
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
            diary.id = id
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
