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
    @State private var currentWeather: ForecastList? = nil
    @State private var location: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Enter the place", text: $location)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        Task {
                            await getForecast(for: location, forecast: &forecast, cW: &currentWeather)
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
                Spacer()
                
                if currentWeather != nil {
                    NavigationLink("View") {
                        CurrentWeatherView(currentWeather: currentWeather, forecast: forecast)
                    }
                }
                
                Spacer()
                Spacer()
            }
            .padding()
            .navigationTitle("YourWeather")
        
        }
    }
    
    func getForecast(for locale: String, forecast: inout Forecast?, cW: inout ForecastList?) async {
        do {
            let coded = try await CLGeocoder().geocodeAddressString(locale)
            let lat = coded[0].location?.coordinate.latitude ?? 0.0
            let lon = coded[0].location?.coordinate.longitude ?? 0.0
            
            let forecast_temp: Forecast = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/forecast?lat=\(Double(lat))&lon=\(Double(lon) )&appid=e312666f8cbdc4aa3610ab1d5f023ed2&units=metric", strategy: .convertFromSnakeCase)
            
            let currentWeather: ForecastList = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)9&lon=\(lon)&appid=e312666f8cbdc4aa3610ab1d5f023ed2&units=metric", strategy: .convertFromSnakeCase)
            
            cW = currentWeather
            forecast = forecast_temp
        } catch {
            print("Error getting location: \(error.localizedDescription)")
        }

    }
    
    func getCurrentLocal() {
        
    }
    
}

#Preview {
    ContentView()
}
