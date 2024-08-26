//
//  Forecast.swift
//  YourWeather
//
//  Created by Caique Ferraz on 23/08/24.
//

import Foundation

struct Forecast: Codable {
    struct ForecastList: Codable {
        let dt: Date
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
        }
        let weather: [Weather]
        
        struct Rain: Codable {
            enum CodingKeys: String, CodingKey {
                case _3h = "3h"
            }
            let _3h: Double
        }
        let rain: Rain?
    }
    let list: [ForecastList]
    
    struct City: Codable {
        let name: String
        let sunrise: Date
        let sunset: Date
    }
    let city: City
}
