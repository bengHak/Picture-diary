//
//  WeatherType.swift
//  PictureDiary
//
//  Created by byunghak on 2022/04/24.
//

import Foundation

enum WeatherType: Int16 {
    case sunny = 0
    case cloudy = 1
    case rain = 2
    case snow = 3
    
    func getString() -> String {
        switch self {
        case .sunny:
            return "sunny"
        case .cloudy:
            return "cloudy"
        case .rain:
            return "rain"
        case .snow:
            return "snow"
        }
    }
}
