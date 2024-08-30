//
//  CurrentWeatherView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 26/08/24.
//

import SwiftUI

struct CurrentWeatherView: View {
    @Environment(\.dismiss) var dismiss
    var weatherData: WeatherData?
    
    var body: some View {

        ZStack {
            weatherData?.forecast.current.weather.first?.background
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    ZStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(weatherData?.cityInfo.first?.name ?? "")
                            .font(.title)
                            .foregroundStyle(.white)
                        
                    }
                    
                    ScrollView {
                        
                        VStack(alignment: .leading) {
                            
                            HStack {
                                Text(String("\(Int(weatherData?.forecast.current.temp ?? 0))°"))
                                    .font(.system(size: 70))
                                    .fontWeight(.light)
                                    .foregroundStyle(.white)
                                    .shadow( radius: 10)
                                
                                Spacer()
                                
                                Image(weatherData?.forecast.current.weather.first?.icon ?? "")
                                    .resizable()
                                    .frame(width: 90, height: 90)
                            }
                            VStack(alignment: .leading){
                                
                                Text(weatherData?.forecast.current.weather.first?.description.capitalized ?? "")
                                    .fontWeight(.semibold)
                                
                                Text(weatherData?.getDate(from: weatherData?.forecast.current.dt ?? 0.0).formatted(date: .complete, time: .omitted) ?? "")
                                    .foregroundStyle(.white)
                                
                                
                                Text(weatherData?.getDate(from: weatherData?.forecast.current.dt ?? 0.0).formatted(date: .omitted, time: .shortened) ?? "XX:XX")
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                                
                                FutureForecastView(weatherData: weatherData)
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
        @State var weather: WeatherData? = nil
        
        var body: some View {
            CurrentWeatherView(weatherData: weather)
                .task {
                    do {
                        let forecastAux: Forecast = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/3.0/onecall?lat=-25.4371499&lon=-49.347251&appid=\(API_KEY)&units=metric", strategy: .convertFromSnakeCase)
                        
                        let cityInfo: [CityInfo] = try await ApiHandling().getJson(endpoint: "http://api.openweathermap.org/geo/1.0/reverse?lat=-25.4371499&lon=-49.347251&appid=\(API_KEY)", strategy: .convertFromSnakeCase)
                        
                        weather = WeatherData(cityInfo: cityInfo, forecast: forecastAux)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    return previewView()
    
}
