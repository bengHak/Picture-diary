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
    case uploadDiary(content: String, weather: WeatherType, imageURL: String)
    case uploadDiaryImage(data: Data)
}

extension DiaryAPI: ServiceAPI {
    var path: String {
        switch self {
        case .fetchDiaryList(_,_):
            return "/diary/list/me"
        case .fetchDiary(let id):
            return "/diary/\(id)"
        case .uploadDiary(_,_,_):
            return "/diary"
        case .uploadDiaryImage(_):
            return "/diary/image"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchDiaryList(_,_):
            return .get
        case .fetchDiary(_):
            return .get
        case .uploadDiary(_,_,_):
            return .post
        case .uploadDiaryImage(_):
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
        case .fetchDiary(_):
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
        }
    }
}
