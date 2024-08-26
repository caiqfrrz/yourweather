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
                    Text(forecast?.list[0].dt.formatted(date: .omitted, time: .complete) ?? "Error")
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
            
            return try await ApiHandling().getJson(lat: lat, lon: lon)
        } catch {
            print("Error getting location: \(error.localizedDescription)")
        }
        return nil
    }
    
}

#Preview {
    ContentView()
}
