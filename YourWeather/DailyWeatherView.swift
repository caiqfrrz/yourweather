//
//  DailyWeatherView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 30/08/24.
//

import SwiftUI

struct DailyWeatherView: View {
    @Binding var weather: WeatherData
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Text("DAILY FORECAST")
                
                Image(systemName: "calendar")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            
            ForEach(weather.forecast.daily, id: \.dt) { day in
                if weather.getDate(from: day.dt) > weather.getDate(from: weather.forecast.current.dt) {
                    HStack {
                        Text(weather.getDate(from: day.dt).weekDay)
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Image(day.weather.first?.icon ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                        
                        Spacer()
                        
                        Text("Min: \(Int(day.temp.min))°")
                            .foregroundStyle(.secondary)
                        
                        Text("Max: \(Int(day.temp.max))°")
                            .foregroundStyle(.secondary)
                        
                    }
                }
                Rectangle()
                    .frame(height: 1)
                    .opacity(0.1)
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 20))
        
    }
}

#Preview {
    struct previewView: View {
        @State var forecast: WeatherData = .mock
        
        var body: some View {
            DailyWeatherView(weather: $forecast)
        }
    }
    
    return previewView()
    
}

extension Date {
    var weekDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let weekDay = dateFormatter.string(from: self)
        return weekDay
    }
}
