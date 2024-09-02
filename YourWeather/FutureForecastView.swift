
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
        VStack(alignment: .leading) {

                HStack {
                    Text("HOURLY FORECAST")
                    
                    Image(systemName: "clock")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top)
            
            Rectangle()
                .frame(height: 1)
                .opacity(0.1)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(data.forecast.hourly, id: \.dt) { hour in
                        if data.getDate(from: hour.dt) > data.getDate(from: data.forecast.current.dt) {
                            VStack {
                                Text("\(Int(hour.temp))°")
                                    .foregroundStyle(.white)
                                    .font(.title3.bold())
                                
                                Image(hour.weather.first?.icon ?? "")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                
                                Text(data.getDate(from: hour.dt).formatted(date: .omitted, time: .shortened))
                                    .foregroundStyle(.white)
                                    .font(.caption)
                            }
                            .padding(.trailing)
                        }
                    }
                }
                .padding(.bottom)
            }
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 20))
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
