//
//  Forecast.swift
//  YourWeather
//
//  Created by Caique Ferraz on 23/08/24.
//

import Foundation
import SwiftUI

struct WeatherData: Codable, Identifiable {
    let id = UUID()
    let cityInfo: [CityInfo]
    let forecast: Forecast
}

struct CityInfo: Codable {
    let name: String
    let localNames: LocalNames?
    let country: String?
    
    struct LocalNames: Codable {
        let en: String?
    }
}

struct Forecast: Codable {
    
    let lat: Double
    let lon: Double
    let timezoneOffset: Int?
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    
    
    struct Current: Codable {
        let dt: TimeInterval
        let temp: Double
        let weather: [Weather]
    }
    
    struct Hourly: Codable {
        let dt: TimeInterval
        let temp: Double
        let weather: [Weather]
    }
    
    struct Daily: Codable {
        let dt: TimeInterval
        let weather: [Weather]
        let temp: Temp
        
        struct Temp: Codable {
            let min: Double
            let max: Double
        }
    }
    
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
    
}

extension WeatherData {
    func getDate(from dt: TimeInterval) -> Date {
        let date = Date(timeIntervalSince1970: dt)
        let systemTimezoneOffset = TimeInterval(TimeZone.current.secondsFromGMT(for: date))
        let totalOffset = TimeInterval(forecast.timezoneOffset ?? 0) - systemTimezoneOffset
        
        return date.addingTimeInterval(totalOffset)
    }
}



