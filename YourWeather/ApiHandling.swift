//
//  ApiHandling.swift
//  YourWeather
//
//  Created by Caique Ferraz on 24/08/24.
//

import Foundation

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
}
