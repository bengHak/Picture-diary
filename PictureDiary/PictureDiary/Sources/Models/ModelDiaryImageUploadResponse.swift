//
//  ModelDiaryImageUploadResponse.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/24.
//

import Foundation

struct ModelDiaryImageUploadResponseWithProgress {
    var progress: Double
    var response: ModelDiaryImageUploadResponse?
}

struct ModelDiaryImageUploadResponse: Decodable {
    var imageUrl: String?
}
