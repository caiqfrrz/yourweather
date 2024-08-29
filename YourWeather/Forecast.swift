//
//  Forecast.swift
//  YourWeather
//
//  Created by Caique Ferraz on 23/08/24.
//

import Foundation
import SwiftUI

struct ForecastList: Codable, Identifiable {
    
    let id = UUID()
    let dt: TimeInterval
    let timezone: Int?
    
    var localDate: Date {
        let date = Date(timeIntervalSince1970: dt)
        let systemTimezoneOffset = TimeInterval(TimeZone.current.secondsFromGMT(for: date))
        let totalOffset = TimeInterval(timezone ?? 0) - systemTimezoneOffset
        
        return date.addingTimeInterval(totalOffset)
    }
    
    struct Sys: Codable {
        let country: String?
    }
    let sys: Sys?
    
    struct Coords: Codable {
        let lat: Double
        let lon: Double
    }
    let coord: Coords?
    
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
            if icon == "01n" || icon == "02n" || icon == "03n" || icon == "04n" || icon == "09n" || icon == "10n" || icon == "11n" || icon == "13n" || icon == "50n" {
                return LinearGradient(stops: [.init(color: Color(red: 0, green: 0, blue: 0.4), location: 0.1),
                                              .init(color: Color(red: 0.3, green: 0.3, blue: 0.3), location: 1)], startPoint: .top, endPoint: .bottom)
            } else {
                return LinearGradient(stops: [.init(color: Color(red: 0.7, green: 0.6, blue: 0), location: 0),
                                              .init(color: Color(red: 0.1, green: 0.5, blue: 0.9), location: 0.5)], startPoint: .top, endPoint: .bottom)
            }
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

struct Forecast: Codable{
    
    let list: [ForecastList]
    
    var forecastTimes: [Date] {
        var times = [Date]()
        for aux in list {
            let date = Date(timeIntervalSince1970: aux.dt)
            let systemTimezoneOffset = TimeInterval(TimeZone.current.secondsFromGMT(for: date))
            let totalOffset = TimeInterval(city.timezone ?? 0) - systemTimezoneOffset
            
            times.append(date.addingTimeInterval(totalOffset))
        }
        return times
    }
    
    struct City: Codable {
        let name: String
        let timezone: Int?
        let country: String
        
        struct Coords: Codable {
            let lat: Double
            let lon: Double
        }
        let coord: Coords?
    }
    let city: City
}


