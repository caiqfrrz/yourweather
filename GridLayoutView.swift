//
//  GridLayoutView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 28/08/24.
//

import SwiftUI

struct GridLayoutView: View {
    @Binding var currentWeather: ForecastList?
    @Binding var currentForecast: Forecast?
    @Binding var cityList: [ForecastList]
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    @State var navigation = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(cityList) { city in
                    Button {
                        Task {
                            currentWeather = await ApiHandling().getForecast(lat: city.coord?.lat ?? 0.0, lon: city.coord?.lon ?? 0, type: "weather")
                            currentForecast = await ApiHandling().getForecast(lat: city.coord?.lat ?? 0.0, lon: city.coord?.lon ?? 0, type: "forecast")
                        }
                        navigation = true
                    } label: {
                        VStack {
                            Text("\(Int(city.main.temp))°")
                                .font(.title)
                                .foregroundStyle(.white)
                            
                            Text(city.name ?? "")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            
                            Text(city.weather.first?.description.capitalized ?? "")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        .frame(width: 150, height: 120)
                        .clipShape(.rect(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.ultraThinMaterial)
                        )
                        .shadow(radius: 5)
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationDestination(isPresented: $navigation, destination: {
            CurrentWeatherView(currentWeather: $currentWeather, forecast: $currentForecast)
        })
    }
}

#Preview {
    struct previewView: View {
        @State var currentWeather: ForecastList? = nil
        @State var cityList: [ForecastList] = []
        @State var forecast: Forecast? = nil
        
        var body: some View {
            GridLayoutView(currentWeather: $currentWeather, currentForecast: $forecast, cityList: $cityList)
                .task {
                    do {
                        currentWeather = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/weather?lat=-25.4371499&lon=-49.347251&appid=e312666f8cbdc4aa3610ab1d5f023ed2&units=metric", strategy: .convertFromSnakeCase)
                        
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    return previewView()
}
