//
//  GridCitySquareView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 29/08/24.
//

import SwiftUI

struct GridCitySquareView: View {
    @State var weather: WeatherData

    var body: some View {
        VStack {
            Text("\(Int(weather.forecast.current.temp))°")
                .font(.title)
                .foregroundStyle(.white)
            
            Text(weather.cityInfo.first?.name ?? "")
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text(weather.forecast.current.weather.first?.description.capitalized ?? "")
                .font(.caption)
                .foregroundStyle(.gray)
            
        }
        .frame(width: 150, height: 120)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 5)
        .padding(.vertical, 5)

    }
}

#Preview {
    struct previewView: View {
        @State var currentWeather: WeatherData = .mock
        
        var body: some View {
            GridCitySquareView(weather: currentWeather)
        }
    }
    
    return previewView()
}
