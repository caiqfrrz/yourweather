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
    @Environment(\.scenePhase) private var scenePhase
    
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
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                Task {
                    print("App became active")
                    await cityList.updateList()
                }
            }
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
