//
//  ServiceAPI.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/17.
//

import Moya
import SwiftKeychainWrapper

protocol ServiceAPI: TargetType { }

extension ServiceAPI {
    var baseURL: URL { URL(string: "http://ssgssg.ga")! }
    var headers: [String: String]? {
        return ["Authorization": KeychainWrapper.getValue(forKey: .accessToken) ?? ""]
    }
}
