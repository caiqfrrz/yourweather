//
//  GridLayoutView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 28/08/24.
//

import SwiftUI
import CoreHaptics

struct GridLayoutView: View {
    @Binding var currentWeather: ForecastList?
    @Binding var currentForecast: Forecast?
    @Binding var cityList: [ForecastList]
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    @State var navigation = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(cityList) { city in
                    Button {
//                        Task {
//                            currentWeather = await ApiHandling().getForecast(lat: city.coord?.lat ?? 0.0, lon: city.coord?.lon ?? 0, type: "weather")
//                            currentForecast = await ApiHandling().getForecast(lat: city.coord?.lat ?? 0.0, lon: city.coord?.lon ?? 0, type: "forecast")
//                        }
//                        navigation = true
                    } label: {
                        GridCitySquareView(weather: city)
                            .onTapGesture {
                                Task {
                                    currentWeather = await ApiHandling().getForecast(lat: city.coord?.lat ?? 0.0, lon: city.coord?.lon ?? 0, type: "weather")
                                    currentForecast = await ApiHandling().getForecast(lat: city.coord?.lat ?? 0.0, lon: city.coord?.lon ?? 0, type: "forecast")
                                }
                                navigation = true
                            }
                            .onLongPressGesture(perform: { removeCity(city) })
                            .animation(.easeOut, value: cityList.count)
                            .sensoryFeedback(.impact, trigger: cityList.count)
                    }
                }
            }
        }
        .navigationDestination(isPresented: $navigation, destination: {
            CurrentWeatherView(currentWeather: $currentWeather, forecast: $currentForecast)
        })
    }
    
    func removeCity(_ city: ForecastList) {

            cityList.removeAll(where: {$0.id == city.id})

    }
}

#Preview {
    struct previewView: View {
        @State var currentWeather: ForecastList? = nil
        @State var cityList: [ForecastList] = []
        @State var forecast: Forecast? = nil
        
        var body: some View {
            GridLayoutView(currentWeather: $currentWeather, currentForecast: $forecast, cityList: $cityList)
                .task {
                    do {
                        currentWeather = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/weather?lat=-25.4371499&lon=-49.347251&appid=\(API_KEY)&units=metric", strategy: .convertFromSnakeCase)
                        
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    return previewView()
}
