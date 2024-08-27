//
//  CurrentWeatherView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 26/08/24.
//

import SwiftUI

struct CurrentWeatherView: View {
    let currentWeather: ForecastList?
    let forecast: Forecast?
    
    var body: some View {
        ZStack {
            LinearGradient(stops: [.init(color: Color(red: 0, green: 0, blue: 0.4), location: 0.1),
                                   .init(color: Color(red: 0.1, green: 0, blue: 0.3), location: 1)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack {
                VStack {
                    Text(currentWeather?.name ?? "")
                        .font(.title)
                        .foregroundStyle(.white)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(String("\(Int(currentWeather?.main.temp ?? 0))°"))
                                .font(.system(size: 70))
                                .fontWeight(.light)
                                .foregroundStyle(.white)
                                .padding(.horizontal)
                                .shadow(color: .black, radius: 10)
                        
                            Spacer()
                            
                            AsyncImage(url: currentWeather?.weather.first?.iconURL) { image in
                                image
                                    .resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 120, height: 120)
                        }
                        VStack(alignment: .leading){
                            Text(currentWeather?.localDate.formatted(date: .complete, time: .omitted) ?? "")
                                .foregroundStyle(.white)
                            
                            Text(currentWeather?.localDate.formatted(date: .omitted, time: .shortened) ?? "XX:XX")
                                .font(.footnote)
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal)
                    }
                }
                FutureForecastView(forecast: forecast, time: currentWeather?.localDate ?? Date())
                    .padding(.horizontal)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 10))
                    .padding(.vertical)
                
                Spacer()
            
            }
            .padding()
        }
    }
}

#Preview {
    
    struct previewView: View {
        @State var currentWeather: ForecastList? = nil
        @State var currentForecast: Forecast? = nil
        
        var body: some View {
            CurrentWeatherView(currentWeather: currentWeather, forecast: currentForecast)
                .task {
                    do {
                        currentWeather = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/weather?lat=-25.4371499&lon=-49.347251&appid=e312666f8cbdc4aa3610ab1d5f023ed2&units=metric", strategy: .convertFromSnakeCase)
                        
                        currentForecast = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/forecast?lat=-25.4371499&lon=-49.347251&appid=e312666f8cbdc4aa3610ab1d5f023ed2&units=metric", strategy: .convertFromSnakeCase)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    return previewView()
    
}
