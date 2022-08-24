//
//  ModelCommonResponse.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/24.
//

import Foundation

struct CommonResponse: Decodable {
    var responseMessage: String?
}

enum ResponseMessage: String {
    case postStampSuccess = "도장 찍기 성공"
}
