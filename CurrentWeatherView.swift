//
//  CurrentWeatherView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 26/08/24.
//

import SwiftUI

struct CurrentWeatherView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var currentWeather: ForecastList?
    @Binding var forecast: Forecast?
    
    var body: some View {

        ZStack {
            currentWeather?.weather.first?.background
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    ZStack {
                        Button {
                            currentWeather = nil
                            forecast = nil
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(currentWeather?.name ?? "")
                            .font(.title)
                            .foregroundStyle(.white)
                        
                    }
                    
                    ScrollView {
                        
                        VStack(alignment: .leading) {
                            
                            HStack {
                                Text(String("\(Int(currentWeather?.main.temp ?? 0))°"))
                                    .font(.system(size: 70))
                                    .fontWeight(.light)
                                    .foregroundStyle(.white)
                                    .shadow( radius: 10)
                                
                                Spacer()
                                
                                Image(currentWeather?.weather.first?.icon ?? "")
                                    .resizable()
                                    .frame(width: 90, height: 90)
                            }
                            VStack(alignment: .leading){
                                
                                Text(currentWeather?.weather.first?.description.capitalized ?? "")
                                    .fontWeight(.semibold)
                                
                                Text(currentWeather?.localDate.formatted(date: .complete, time: .omitted) ?? "")
                                    .foregroundStyle(.white)
                                
                                
                                Text(currentWeather?.localDate.formatted(date: .omitted, time: .shortened) ?? "XX:XX")
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                                
                                FutureForecastView(forecast: forecast, time: currentWeather?.localDate ?? Date())
                                    .padding(.horizontal)
                                    .background(.ultraThinMaterial)
                                    .clipShape(.rect(cornerRadius: 10))
                                    .padding(.vertical)
                            }
                        }
                    }
                }
                
                Spacer()
            
            }
            .padding(.horizontal)
        }
        .toolbar(.hidden)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    
    struct previewView: View {
        @State var currentWeather: ForecastList? = nil
        @State var currentForecast: Forecast? = nil
        
        var body: some View {
            CurrentWeatherView(currentWeather: $currentWeather, forecast: $currentForecast)
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
