//
//  ColorType.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/14.
//

import Foundation

enum PaletteColorType: String, CaseIterable {
    case white = "color-drawing-white"
    case black = "color-drawing-black"
    case red = "color-drawing-red"
    case orange = "color-drawing-orange"
    case yellow = "color-drawing-yellow"
    case green = "color-drawing-green"
    case skyblue = "color-drawing-skyblue"
    case blue = "color-drawing-blue"
    case darkblue = "color-drawing-darkblue"
    case purple = "color-drawing-purple"
    case beige = "color-drawing-beige"
    case brown = "color-drawing-brown"

    var numberValue: Int {
        switch self {
        case .white:
            return 0
        case .black:
            return 1
        case .red:
            return 2
        case .orange:
            return 3
        case .yellow:
            return 4
        case .green:
            return 5
        case .skyblue:
            return 6
        case .blue:
            return 7
        case .darkblue:
            return 8
        case .purple:
            return 9
        case .beige:
            return 10
        case .brown:
            return 11
        }
    }

    static func getByHashValue(_ num: Int) -> PaletteColorType {
        switch num {
        case 0:
            return .white
        case 1:
            return .black
        case 2:
            return .red
        case 3:
            return .orange
        case 4:
            return .yellow
        case 5:
            return .green
        case 6:
            return .skyblue
        case 7:
            return .blue
        case 8:
            return .darkblue
        case 9:
            return .purple
        case 10:
            return .beige
        case 11:
            return .brown
        default:
            return .black
        }
    }
}
