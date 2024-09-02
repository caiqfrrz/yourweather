//
//  CityList.swift
//  YourWeather
//
//  Created by Caique Ferraz on 30/08/24.
//

import Foundation

// Class that contains the list of cities the user saved

@Observable
class CityList {
    static var shared = CityList()
    
    var list: [WeatherData]
    
    private init() {
        self.list = []
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("list.data")
    }
    
    func getCity(at index: Int) -> WeatherData {
        return list[index]
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
                list[index].forecast = weatherData.forecast
                list[index].cityInfo = weatherData.cityInfo
            } else {
                print("Failed to update city data")
            }
        }
    }
    
    func load() async throws {
        let task = Task<[WeatherData], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let list = try JSONDecoder().decode([WeatherData].self, from: data)
            return list
        }
        let list = try await task.value
        self.list = list
    }
    
    func save(list: [WeatherData]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(list)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        
        _ = try await task.value
    }
    
}
