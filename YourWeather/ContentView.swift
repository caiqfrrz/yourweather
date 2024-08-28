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
    @State private var cityList: [ForecastList] = []
    @State private var location: String = ""
    
    @State private var navigation = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Enter the place", text: $location)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        Task {
                            await getList(for: location, cW: &cityList)
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .padding()
            .navigationTitle("YourWeather")
            
            
            List {
                ForEach(cityList, id: \.id) { aux in
                    Button {
                        Task {
                            forecast = await getForecast(lat: aux.coord?.lat ?? 0.0, lon: aux.coord?.lon ?? 0.0)
                            currentWeather = aux
                            navigation = true
                        }
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(aux.name ?? ""), \(aux.sys?.country ?? "N/A")")
                                    .fontWeight(.bold)
                                
                                Text("\(Int(aux.main.temp))°")
                                    .font(.title2)
                            }
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $navigation, destination: {
                CurrentWeatherView(currentWeather: currentWeather, forecast: forecast)
            })
        }
    }
    
    func getForecast(lat: Double, lon: Double) async -> Forecast? {
        do {
            let forecast_aux: Forecast = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/forecast?lat=-25.4371499&lon=-49.347251&appid=e312666f8cbdc4aa3610ab1d5f023ed2&units=metric", strategy: .convertFromSnakeCase)
            
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

//            let currentWeather: ForecastList = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)9&lon=\(lon)&appid=e312666f8cbdc4aa3610ab1d5f023ed2&units=metric", strategy: .convertFromSnakeCase)
            
        } catch {
            print("Error getting location: \(error.localizedDescription)")
        }

    }
    
}

#Preview {
    ContentView()
}
