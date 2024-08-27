//
//  Forecast.swift
//  YourWeather
//
//  Created by Caique Ferraz on 23/08/24.
//

import Foundation
import SwiftUI

struct ForecastList: Codable {
    
    let dt: TimeInterval
    let timezone: Int?
    
    var localDate: Date {
        let date = Date(timeIntervalSince1970: dt)
        let systemTimezoneOffset = TimeInterval(TimeZone.current.secondsFromGMT(for: date))
        let totalOffset = TimeInterval(timezone ?? 0) - systemTimezoneOffset
        
        return date.addingTimeInterval(totalOffset)
    }
    struct Main: Codable {
        let temp: Double
        let feelsLike: Double?
        let humidity: Int
    }
    let main: Main
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
        
        var iconURL: URL {
            URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!
        }
        var background: LinearGradient {
            if id >= 200 && id <= 232 {
                return LinearGradient(stops: [.init(color: Color(red: 0.6, green: 0.5, blue: 0.9), location: 0.8),
                                              .init(color: Color(red: 0.5, green: 0.4, blue: 0.7), location: 0.2)], startPoint: .top, endPoint: .bottom)
            }
            return LinearGradient(stops: [.init(color: Color(red: 0.6, green: 0.5, blue: 0.9), location: 0.8),
                                          .init(color: Color(red: 0.5, green: 0.4, blue: 0.7), location: 0.2)], startPoint: .top, endPoint: .bottom)
        }
    }
    let weather: [Weather]
    
    struct Rain: Codable {
        enum CodingKeys: String, CodingKey {
            case _3h = "3h"
        }
        let _3h: Double
    }
    let rain: Rain?
    let name: String?
}

struct Forecast: Codable {
    
    let list: [ForecastList]
    
    struct City: Codable {
        let name: String
        let sunrise: Date
        let sunset: Date
    }
    let city: City
}
