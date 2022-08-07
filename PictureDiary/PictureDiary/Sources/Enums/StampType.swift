//
//  StampType.swift
//  PictureDiary
//
//  Created by byunghak on 2022/07/11.
//

import Foundation
import UIKit

enum StampType: String, CaseIterable, Decodable {
    case GRAL
    case DOTHIS
    case GOOD
    case GREATJOB
    case PERFECT
    case OH
    case ZZUGUL
    case HUNDRED
    case HOENG
    case INTERESTING
    case LOL
    case ZZANG

    var imageName: String { "stamp_\(self.rawValue)" }
}
