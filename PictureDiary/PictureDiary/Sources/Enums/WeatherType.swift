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
            return "SUN"
        case .cloudy:
            return "CLOUD"
        case .rain:
            return "RAIN"
        case .snow:
            return "SNOW"
        }
    }
    
    static func initWithString(_ keyword: String) -> WeatherType {
        switch keyword {
        case WeatherType.cloudy.getString():
            return .cloudy
        case WeatherType.rain.getString():
            return .rain
        case WeatherType.snow.getString():
            return .snow
        case WeatherType.sunny.getString():
            fallthrough
        default:
            return .sunny
        }
    }
}
