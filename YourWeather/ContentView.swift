//
//  ContentView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 23/08/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var forecast: Forecast? = nil
    @State private var location: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Type your city:") {
                    TextField("Location", text: $location)
                }
                Section("Name:") {
                    Text(forecast?.city.name ?? "Name")
                }
                Section("Temperature:") {
                    Text(String(forecast?.list[0].main.temp ?? 0.0))
                }
                Section("Time:") {
                    Text(forecast?.list[0].dt.formatted(date: .omitted, time: .shortened) ?? "Error")
                }
            }
            .navigationTitle("YourWeather")
            .toolbar {
                Button("Get") {
                    Task {
                        forecast = await getForecast(for: location)
                    }
                }
            }
        
        }
    }
    
    func getForecast(for locale: String) async -> Forecast? {
        do {
            let coded = try await CLGeocoder().geocodeAddressString(locale)
            let lat = coded[0].location?.coordinate.latitude ?? 0.0
            let lon = coded[0].location?.coordinate.longitude ?? 0.0
            
            let forecast: Forecast = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/forecast?lat=\(Double(lat))&lon=\(Double(lon) )&appid=e312666f8cbdc4aa3610ab1d5f023ed2&units=metric", strategy: .convertFromSnakeCase)
            
            return forecast
        } catch {
            print("Error getting location: \(error.localizedDescription)")
        }
        return nil
    }
    
}

#Preview {
    ContentView()
}
