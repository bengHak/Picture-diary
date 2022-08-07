//
//  ModelDiaryResponse.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/20.
//

import Foundation

struct ModelDiaryResponse: Decodable {
    var createdDate: String?
    var diaryId: Int?
    var imageUrl: String?
    var imageData: Data?
    var weather: String?
    var content: String?
    var stampList: [ModelStamp]?

    func getDate() -> Date {
        guard let createdDate = createdDate else { return Date() }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return dateFormatter.date(from: createdDate) ?? Date()
    }

    func getWeather() -> WeatherType {
        guard let weather = weather else { return .sunny }
        return WeatherType.initWithString(weather)
    }
}

struct ModelStamp: Decodable {
    var stampId: Int?
    var stampType: String?
    var x: Double?
    var y: Double?
}
