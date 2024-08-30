//
//  GridLayoutView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 28/08/24.
//

import SwiftUI
import CoreHaptics

struct GridLayoutView: View {
    @Binding var cityList: [WeatherData]
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(cityList) { city in
                    NavigationLink {
                        CurrentWeatherView(weatherData: city)
                    } label: {
                        GridCitySquareView(weather: city)
//                            .onTapGesture {
//                                Task {
//                                    currentForecast = await ApiHandling().getForecast(lat: city.coord?.lat ?? 0.0, lon: city.coord?.lon ?? 0)
//                                }
//                                navigation = true
//                            }
//                            .onLongPressGesture(perform: { removeCity(city) })
                    }
                }
            }
        }
    }
    
    func removeCity(_ city: WeatherData) {
            cityList.removeAll(where: {$0.id == city.id})
    }
}

#Preview {
    struct previewView: View {
        @State var cityList: [WeatherData] = []
        
        var body: some View {
            GridLayoutView( cityList: $cityList)
                
        }
    }
    
    return previewView()
}
