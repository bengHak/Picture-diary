//
//  ServiceAPI.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/17.
//

import Moya

protocol ServiceAPI: TargetType { }

extension ServiceAPI {
    var baseURL: URL { URL(string: "http://ssgssg.ga")! }
}

