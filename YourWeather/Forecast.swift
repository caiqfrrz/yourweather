//
//  Forecast.swift
//  YourWeather
//
//  Created by Caique Ferraz on 23/08/24.
//

import Foundation
import SwiftUI

// Struct that receives the API's calls: CityInfo and Forecast

struct WeatherData: Codable, Identifiable, Equatable {

    let id = UUID()
    var cityInfo: [CityInfo]
    var forecast: Forecast
    
    init(cityInfo: [CityInfo], forecast: Forecast) {
        self.cityInfo = cityInfo
        self.forecast = forecast
    }
}

struct CityInfo: Codable, Equatable {
    let name: String
    let localNames: LocalNames?
    let country: String?
    
    struct LocalNames: Codable, Equatable {
        let en: String?
    }
}

struct Forecast: Codable, Equatable {
    
    let lat: Double
    let lon: Double
    let timezoneOffset: Int?
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
    
    
    struct Current: Codable, Equatable {
        let dt: TimeInterval
        let temp: Double
        let weather: [Weather]
    }
    
    struct Hourly: Codable, Equatable {
        let dt: TimeInterval
        let temp: Double
        let weather: [Weather]
    }
    
    struct Daily: Codable, Equatable {
        let dt: TimeInterval
        let weather: [Weather]
        let temp: Temp
        
        struct Temp: Codable, Equatable {
            let min: Double
            let max: Double
        }
    }
    
    struct Weather: Codable, Equatable {
        let id: Int
        let main: String
        let description: String
        let icon: String
        
        var iconURL: URL {
            URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!
        }
        var background: LinearGradient {
            if icon == "01d" || icon == "02d" {
                return LinearGradient.sunny()
            } else if icon == "01n" || icon == "02n" {
                return LinearGradient.clearNight()
            } else {
                return LinearGradient.cloudy()
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



