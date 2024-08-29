//
//  ApiHandling.swift
//  YourWeather
//
//  Created by Caique Ferraz on 24/08/24.
//

import Foundation
import CoreLocation

final class ApiHandling {
    
    enum getAPIError: Error {
        case invalidURL
        case invalidResponse
        case invalidData
    }
    
    func getJson<T: Codable>(endpoint: String, strategy: JSONDecoder.KeyDecodingStrategy) async throws -> T {
        
        guard let url = URL(string: endpoint) else {
            throw getAPIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw getAPIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = strategy
            return try decoder.decode(T.self, from: data)
        } catch {
            throw getAPIError.invalidData
        }
    }
    
    func getForecast<T: Codable>(for locale: String, type: String) async -> T? {
        do {
            let coded = try await CLGeocoder().geocodeAddressString(locale)
            
            let lat = coded[0].location?.coordinate.latitude ?? 0.0
            let lon = coded[0].location?.coordinate.longitude ?? 0.0
            
            let forecast_aux: T = try await getJson(endpoint: "https://api.openweathermap.org/data/2.5/\(type == "weather" ? "weather" : "forecast")?lat=\(Double(lat))&lon=\(Double(lon))&appid=\(API_KEY)&units=metric", strategy: .convertFromSnakeCase)
            
            return forecast_aux
            
        } catch {
            print("Error getting location: \(error.localizedDescription)")
        }
        return nil
    }
    
    func getForecast<T: Codable>(lat: Double, lon: Double, type: String) async -> T? {
        do {
            let forecast_aux: T = try await getJson(endpoint: "https://api.openweathermap.org/data/2.5/\(type == "weather" ? "weather" : "forecast")?lat=\(Double(lat))&lon=\(Double(lon))&appid=\(API_KEY)&units=metric", strategy: .convertFromSnakeCase)
            
            return forecast_aux
            
        } catch {
            print("Error getting location: \(error.localizedDescription)")
        }
        return nil
    }
}
