//
//  ContentView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 23/08/24.
//

import SwiftUI
import CoreLocation


struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var searchVw = LocationSearchService()
    @State private var forecast: Forecast? = nil
    @State private var currentWeather: ForecastList? = nil
    @State private var cityList: [ForecastList] = []
    @State private var location: String = ""
    
    @State private var navigation = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List(searchVw.results) { result in
                    Button {
                        Task {
                            forecast = await getForecast(lat: result.coord.lat, lon: result.coord.lon, type: "forecast")
                            currentWeather = await getForecast(lat: result.coord.lat, lon: result.coord.lon, type: "weather")
                            navigation = true
                        }
                    } label: {
                        VStack(alignment: .leading) {
                            Text(result.title)
                            Text(result.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
            }
            .searchable(text: $searchVw.query)
            .navigationTitle("YourWeather")
            .navigationDestination(isPresented: $navigation, destination: {
                        CurrentWeatherView(currentWeather: currentWeather, forecast: forecast)
                    })
        }
        
//        List {
//            ForEach(cityList, id: \.id) { aux in
//                Button {
//                    Task {
//                        forecast = await getForecast(lat: aux.coord?.lat ?? 0.0, lon: aux.coord?.lon ?? 0.0)
//                        currentWeather = aux
//                        navigation = true
//                    }
//                } label: {
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("\(aux.name ?? ""), \(aux.sys?.country ?? "N/A")")
//                                .fontWeight(.bold)
//                            
//                            Text("\(Int(aux.main.temp))°")
//                                .font(.title2)
//                        }
//                    }
//                }
//            }
//        }
//        .navigationDestination(isPresented: $navigation, destination: {
//            CurrentWeatherView(currentWeather: currentWeather, forecast: forecast)
//        })
    }
}

func getForecast<T: Codable>(lat: Double, lon: Double, type: String) async -> T? {
    do {
        let forecast_aux: T = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/\(type == "weather" ? "weather" : "forecast")?lat=\(Double(lat))&lon=\(Double(lon))&appid=e312666f8cbdc4aa3610ab1d5f023ed2&units=metric", strategy: .convertFromSnakeCase)
        
        return forecast_aux
        
    } catch {
        print("Error getting location: \(error.localizedDescription)")
    }
    return nil
}

func getList(for locale: String, cW: inout [ForecastList]) async {
    do {
        let coded = try await CLGeocoder().geocodeAddressString(locale)
        print(coded.count)
        
        for i in 0..<coded.count {
            guard i < 10 else { return }
            
            let lat = coded[i].location?.coordinate.latitude ?? 0.0
            let lon = coded[i].location?.coordinate.longitude ?? 0.0
            
            let forecast_temp: ForecastList = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/weather?lat=\(Double(lat))&lon=\(Double(lon) )&appid=e312666f8cbdc4aa3610ab1d5f023ed2&units=metric", strategy: .convertFromSnakeCase)
            
            cW.append(forecast_temp)
        }
    } catch {
        print("Error getting location: \(error.localizedDescription)")
    }
    
}



#Preview {
    ContentView()
}
