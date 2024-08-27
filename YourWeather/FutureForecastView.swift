
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
                ForEach(forecast?.list ?? [], id: \.dt) { aux in
                    VStack {
                        if aux.localDate > time {
                            Text("\(Int(aux.main.temp))°")
                                .foregroundStyle(.white)
                                .font(.title2.bold())

                            AsyncImage(url: aux.weather.first?.iconURL)
                                .frame(width: 70, height: 50)
                                .clipped()
                            
                            Text(aux.localDate.formatted(date: .omitted, time: .shortened))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal)
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
                        forecast = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/forecast?lat=22.280851&lon=114.169944&appid=e312666f8cbdc4aa3610ab1d5f023ed2&units=metric", strategy: .convertFromSnakeCase)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    return previewView()
        .preferredColorScheme(.dark)
}
