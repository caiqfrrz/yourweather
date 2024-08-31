//
//  CurrentWeatherView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 26/08/24.
//

import SwiftUI

struct CurrentWeatherView: View {

    @Environment(\.dismiss) var dismiss
    @State var weatherData: WeatherData
    @State var cityList = CityList.shared
    
    var body: some View {
        
        ZStack {
            weatherData.forecast.current.weather.first?.background
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
                        
                        Text(weatherData.cityInfo.first?.name ?? "")
                            .font(.title)
                            .foregroundStyle(.white)
                        
                    }
                    
                    ScrollView(showsIndicators: false) {
                        
                        VStack(alignment: .leading) {
                            
                            HStack {
                                Text(String("\(Int(weatherData.forecast.current.temp))°"))
                                    .font(.system(size: 70))
                                    .fontWeight(.light)
                                    .foregroundStyle(.white)
                                    .shadow( radius: 10)
                                
                                Spacer()
                                
                                Image(weatherData.forecast.current.weather.first?.icon ?? "")
                                    .resizable()
                                    .frame(width: 90, height: 90)
                            }
                            VStack(alignment: .leading){
                                
                                Text(weatherData.forecast.current.weather.first?.description.capitalized ?? "")
                                    .fontWeight(.semibold)
                                
                                Text(weatherData.getDate(from: weatherData.forecast.current.dt).formatted(date: .complete, time: .omitted))
                                    .foregroundStyle(.white)
                                
                                
                                Text(weatherData.getDate(from: weatherData.forecast.current.dt).formatted(date: .omitted, time: .shortened))
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                                
                                FutureForecastView(data: $weatherData)
                                    .padding(.horizontal)
                                    .background(.ultraThinMaterial)
                                    .clipShape(.rect(cornerRadius: 20))
                                    .padding(.vertical)
                                
                                DailyWeatherView(weather: $weatherData)
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
        .onChange(of: cityList.list) { oldList, newList in
                                if let updatedWeatherData = newList.first(where: { $0.id == weatherData.id }) {
                                    weatherData = updatedWeatherData
                                } else {
                                    print("erro")
            }
        }
    }

    }

#Preview {
    
    struct previewView: View {
        @State var weather: WeatherData = .mock
        
        var body: some View {
            CurrentWeatherView(weatherData: weather)
        }
    }
    
    return previewView()
    
}
