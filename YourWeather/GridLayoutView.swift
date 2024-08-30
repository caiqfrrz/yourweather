//
//  GridLayoutView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 28/08/24.
//

import SwiftUI
import CoreHaptics

struct GridLayoutView: View {
    @Binding var cityList: CityList
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(cityList.list) { city in
                    NavigationLink {
                        CurrentWeatherView(weatherData: city)
                    } label: {
                        GridCitySquareView(weather: city)
                    }
                }
            }
        }
        .task {
            print("updated")
            await cityList.updateList()
        }
    }
}

#Preview {
    struct previewView: View {
        @State var cityList = CityList()
        
        var body: some View {
            GridLayoutView( cityList: $cityList)
                
        }
    }
    
    return previewView()
}
