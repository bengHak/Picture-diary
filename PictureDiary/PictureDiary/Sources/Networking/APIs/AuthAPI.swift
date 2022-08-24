//
//  AuthAPI.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/16.
//

import Foundation
import Moya

enum AuthAPI {
    case signin(token: String, provider: ProviderType)
    case signup(token: String, provider: ProviderType)
}

extension AuthAPI: ServiceAPI {
    var path: String {
        switch self {
        case .signin:
            return "/auth/sign-in"
        case .signup:
            return "/auth/sign-up"
        }
    }

    var method: Moya.Method { .post }

    var task: Task {
        switch self {
        case .signin(let token, let provider), .signup(let token, let provider):
            let parameters = ["socialToken": token, "socialType": provider.rawValue]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? { [:] }
}
