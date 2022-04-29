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
