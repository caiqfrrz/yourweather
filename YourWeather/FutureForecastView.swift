
//
//  FutureForecastView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 26/08/24.
//

import SwiftUI

struct FutureForecastView: View {
    @Binding var data: WeatherData
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                    ForEach(0..<16) { index in
                        if data.getDate(from: data.forecast.hourly[index].dt) > data.getDate(from: data.forecast.current.dt) {
                            VStack {
                                Text("\(Int(data.forecast.hourly[index].temp))°")
                                    .foregroundStyle(.white)
                                    .font(.title2.bold())
                                
                                Image(data.forecast.hourly[index].weather.first?.icon ?? "")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                
                                Text(data.getDate(from: data.forecast.hourly[index].dt).formatted(date: .omitted, time: .shortened))
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                
            }
            .padding()
        }
    }
}

#Preview {
    struct previewView: View {
        @State var forecast: WeatherData = WeatherData.mock
        
        var body: some View {
            FutureForecastView(data: $forecast)
        }
    }
    
    return previewView()
        .preferredColorScheme(.dark)
}
