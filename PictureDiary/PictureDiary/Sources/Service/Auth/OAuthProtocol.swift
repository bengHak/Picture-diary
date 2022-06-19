//
//  OAuthProtocol.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/16.
//

import Foundation
import RxSwift

protocol OAuthProtocol {
    func authorize() -> Observable<ModelTokenResponse>
}
