//
//  ApiHandling.swift
//  YourWeather
//
//  Created by Caique Ferraz on 24/08/24.
//

import Foundation

class ApiHandling {
    
    enum getAPIError: Error {
        case invalidURL
        case invalidResponse
        case invalidData
    }
    
    func getJson(lat: Double, lon: Double) async throws -> Forecast {
        let endpoint = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=e312666f8cbdc4aa3610ab1d5f023ed2&units=metric"
        
        guard let url = URL(string: endpoint) else {
            throw getAPIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw getAPIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Forecast.self, from: data)
        } catch {
            throw getAPIError.invalidData
        }
    }
}
