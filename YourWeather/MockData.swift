//
//  MockData.swift
//  YourWeather
//
//  Created by Caique Ferraz on 31/08/24.
//

import Foundation

extension WeatherData {
    static var mock: WeatherData {
        let mockWeather = Forecast.Weather(
            id: 800,
            main: "Clear",
            description: "clear sky",
            icon: "01d"
        )
        
        let mockCurrent = Forecast.Current(
            dt: Date().timeIntervalSince1970,
            temp: 25.0,
            weather: [mockWeather]
        )
        
        let mockHourly = [
            Forecast.Hourly(
                dt: Date().timeIntervalSince1970 + 3600,
                temp: 24.5,
                weather: [mockWeather]
            ),
            Forecast.Hourly(
                dt: Date().timeIntervalSince1970 + 7200,
                temp: 23.0,
                weather: [mockWeather]
            )
        ]
        
        let mockDaily = [
            Forecast.Daily(
                dt: Date().timeIntervalSince1970,
                weather: [mockWeather],
                temp: Forecast.Daily.Temp(min: 15.0, max: 28.0)
            ),
            Forecast.Daily(
                dt: Date().timeIntervalSince1970 + 86400,
                weather: [mockWeather],
                temp: Forecast.Daily.Temp(min: 17.0, max: 27.0)
            )
        ]
        
        let mockForecast = Forecast(
            lat: -25.4371499,
            lon: -49.347251,
            timezoneOffset: -10800,
            current: mockCurrent,
            hourly: mockHourly,
            daily: mockDaily
        )
        
        let mockCityInfo = CityInfo(
            name: "Curitiba",
            localNames: CityInfo.LocalNames(en: "Curitiba"),
            country: "BR"
        )
        
        return WeatherData(
            cityInfo: [mockCityInfo],
            forecast: mockForecast
        )
    }
}
