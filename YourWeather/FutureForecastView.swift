
//
//  FutureForecastView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 26/08/24.
//

import SwiftUI

struct FutureForecastView: View {
    let forecast: Forecast?
    let time: Date
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if let data = forecast {
                    ForEach(0..<8) { index in
                        if data.forecastTimes[index] > time {
                            VStack {
                                Text("\(Int(data.list[index].main.temp))°")
                                    .foregroundStyle(.white)
                                    .font(.title2.bold())
                                
                                Image(data.list[index].weather.first?.icon ?? "")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                
                                Text(data.forecastTimes[index].formatted(date: .omitted, time: .shortened))
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                }
            }
            .padding()
        }
    }
}

#Preview {
    struct previewView: View {
        @State var forecast: Forecast? = nil
        
        var body: some View {
            FutureForecastView(forecast: forecast, time: Date())
                .task {
                    do {
                        forecast = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/forecast?lat=-25.4371499&lon=-49.347251&appid=e312666f8cbdc4aa3610ab1d5f023ed2&units=metric", strategy: .convertFromSnakeCase)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    return previewView()
        .preferredColorScheme(.dark)
}
