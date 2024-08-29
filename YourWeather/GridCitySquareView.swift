//
//  GridCitySquareView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 29/08/24.
//

import SwiftUI

struct GridCitySquareView: View {
    let weather: ForecastList?
    
    var body: some View {
        VStack {
            Text("\(Int(weather?.main.temp ?? 0))°")
                .font(.title)
                .foregroundStyle(.white)
            
            Text(weather?.name ?? "")
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text(weather?.weather.first?.description.capitalized ?? "")
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
        @State var currentWeather: ForecastList? = nil
        
        var body: some View {
            GridCitySquareView(weather: currentWeather)
                .task {
                    do {
                        currentWeather = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/weather?lat=-25.4371499&lon=-49.347251&appid=\(API_KEY)&units=metric", strategy: .convertFromSnakeCase)
                        
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    return previewView()
}
