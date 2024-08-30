//
//  GridCitySquareView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 29/08/24.
//

import SwiftUI

struct GridCitySquareView: View {
    @State var weather: WeatherData?

    var body: some View {
        VStack {
            Text("\(Int(weather?.forecast.current.temp ?? 0))°")
                .font(.title)
                .foregroundStyle(.white)
            
            Text(weather?.cityInfo.first?.name ?? "")
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text(weather?.forecast.current.weather.first?.description.capitalized ?? "")
                .font(.caption)
                .foregroundStyle(.gray)
            
            Text(weather?.getDate(from: weather?.forecast.current.dt ?? 0).formatted(date: .omitted
                                                                                     , time: .shortened) ?? "")
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

#Preview {
    struct previewView: View {
        @State var currentWeather: WeatherData? = nil
        
        var body: some View {
            GridCitySquareView(weather: currentWeather)
                .task {
                    do {
                        let forecastAux: Forecast = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/3.0/onecall?lat=-25.4371499&lon=-49.347251&appid=\(API_KEY)&units=metric", strategy: .convertFromSnakeCase)
                        
                        let cityInfo: [CityInfo] = try await ApiHandling().getJson(endpoint: "http://api.openweathermap.org/geo/1.0/reverse?lat=-25.4371499&lon=-49.347251&appid=\(API_KEY)", strategy: .convertFromSnakeCase)
                        
                        currentWeather = WeatherData(cityInfo: cityInfo, forecast: forecastAux)
                        
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    return previewView()
}
