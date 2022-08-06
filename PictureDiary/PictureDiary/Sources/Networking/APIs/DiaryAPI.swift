//
//  DiaryAPI.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/24.
//

import Foundation
import Moya
import SwiftKeychainWrapper


enum DiaryAPI {
    case fetchDiaryList(lastDiaryId: Int, querySize: Int)
    case fetchDiary(id: Int)
    case fetchRandomDiary
    case stamp(diaryId: Int, stampType: String, x: Double, y: Double)
    case uploadDiary(content: String, weather: WeatherType, imageURL: String)
    case uploadDiaryImage(data: Data)
}

extension DiaryAPI: ServiceAPI {
    var path: String {
        switch self {
        case .fetchDiaryList:
            return "/diary/list/me"
        case .fetchDiary(let id):
            return "/diary/\(id)"
        case .uploadDiary:
            return "/diary"
        case .uploadDiaryImage:
            return "/diary/image"
        case .fetchRandomDiary:
            return "/diary/random"
        case .stamp:
            return "/diary/stamp"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchDiaryList:
            return .get
        case .fetchDiary:
            return .get
        case .uploadDiary:
            return .post
        case .uploadDiaryImage:
            return .post
        case .fetchRandomDiary:
            return .get
        case .stamp:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .fetchDiaryList(let lastDiaryId, let querySize):
            let parameters = [
                "lastDiaryId": lastDiaryId,
                "size": querySize
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .fetchDiary:
            return .requestPlain
        case .uploadDiary(let content, let weather, let imageURL):
            let parameters = [
                "content": content,
                "imageUrl": imageURL,
                "weather": weather.getString()
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .uploadDiaryImage(let data):
            let multipartFormData = [MultipartFormData(
                provider: .data(data),
                name: "image",
                fileName: "drawing_image.png",
                mimeType: "image/png"
            )]
            return .uploadMultipart(multipartFormData)
        case .fetchRandomDiary:
            return .requestPlain
        case .stamp:
            let parameters = [
                "diaryId": "1",
                "stampType": "",
                "x": "1.0",
                "y": "1.0"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
}
