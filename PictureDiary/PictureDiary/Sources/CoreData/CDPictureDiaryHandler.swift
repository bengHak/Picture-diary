//
//  CoreDataHelper.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/28.
//

import CoreData
import UIKit

class CDPictureDiaryHandler {
    static let shared = CDPictureDiaryHandler()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext

    let modelName = "PictureDiary"

    private var cached: [PictureDiary]
    private var cachedRandomDiary: PictureDiary?

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

    /// 코어데이터에 id를 키로 캐싱된 일기 호출
    ///
    /// 랜덤 일기는 id가 '-1' 로 캐싱됨
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

    func getCachedRandomDiary() -> PictureDiary? {
        return cached
            .filter { $0.isRandomDiary }
            .first
    }

    /// Update cached random diary
    func updateCachedRandomDiary(_ diary: ModelDiaryResponse) {
        guard let context = context else { return }

        if let update = getCachedRandomDiary() {
            update.imageUrl = diary.imageUrl
            update.weather = diary.getWeather().rawValue
            update.content = diary.content
            update.stampList = diary.stampList ?? []
            update.didStamp = diary.stamped ?? false
            update.isRandomDiary = true
            do {
                try context.save()
                cached = cached.filter { !$0.isRandomDiary }
                cached.append(update)
            } catch let error {
                print("update error: \(error)")
            }
        } else {
            saveDiary(
                diaryResponse: diary,
                drawing: nil,
                isRandomDiary: true,
                completionHandler: nil
            )
        }
    }

    /// Remove cached diary
    func removeCachedDiary(_ diary: PictureDiary) {
        guard let context = context else { return }
        context.delete(diary)
        try? context.save()
    }

    func saveDiary(
        diaryResponse: ModelDiaryResponse,
        drawing: Data?,
        isRandomDiary: Bool = false,
        completionHandler: ((PictureDiary?, Bool) -> Void)?
    ) {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: modelName, in: context),
              let id = diaryResponse.diaryId,
              let imageUrl = diaryResponse.imageUrl else {
            print("🔴 diary-\(String(describing: diaryResponse.diaryId)) is not cached")
            completionHandler?(nil, false)
            return
        }

        if let cachedDiary = getDiaryById(id) {
            cachedDiary.stampList = diaryResponse.stampList ?? []
            cachedDiary.content = diaryResponse.content
            cached = cached.filter { $0.id != cachedDiary.id }
            cached.append(cachedDiary)
            completionHandler?(cachedDiary, true)
            print("🟢 diary-\(cachedDiary.id) is cached")
            return
        }

        if let diary = NSManagedObject(entity: entity, insertInto: context) as? PictureDiary {
            diary.id = Int64(id)
            diary.date = diaryResponse.getDate()
            diary.weather = diaryResponse.getWeather().rawValue
            diary.drawing = drawing
            diary.content = diaryResponse.content ?? ""
            diary.imageUrl = imageUrl
            diary.didStamp = diaryResponse.stamped ?? false
            diary.stampList = diaryResponse.stampList ?? []
            diary.isRandomDiary = isRandomDiary

            do {
                try context.save()
                cached.append(diary)
                completionHandler?(diary, true)
                print("🟢 diary-\(diary.id) is cached")
            } catch let error as NSError {
                print("🔴 Could not save: \(error)")
                completionHandler?(nil, false)
            }
        }

    }
}
