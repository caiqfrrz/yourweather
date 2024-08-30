//
//  CityList.swift
//  YourWeather
//
//  Created by Caique Ferraz on 30/08/24.
//

import Foundation

@Observable
class CityList {
    private(set) var list: [WeatherData]
    
    init() {
        self.list = []
    }
    
    func getIndex(_ city: WeatherData) -> Int? {
        list.firstIndex(where: {$0.id == city.id})
    }
    
    func addCity(_ city: WeatherData) {
        list.append(city)
    }
    
    func removeCity(_ city: WeatherData) {
        list.removeAll(where: {$0.id == city.id})
    }
    
    func updateList() async {
        for city in list {
            await updateCity(city)
        }
    }
    
    func updateCity(_ city: WeatherData) async {
        if let index = getIndex(city) {
            if let weatherData = await ApiHandling().getWeatherData(lat: city.forecast.lat, lon: city.forecast.lon) {
                list[index] = weatherData
            } else {
                print("Failed to update city data")
            }
        }
    }
}
