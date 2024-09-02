//
//  GridLayoutView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 28/08/24.
//

import SwiftUI
import CoreHaptics

struct GridLayoutView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Binding var cityList: CityList
    let saveAction: ()->Void
    
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
            await cityList.updateList()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .inactive { saveAction() }
        }
    }
}

#Preview {
    struct previewView: View {
        @State var cityList = CityList.shared
        
        var body: some View {
            GridLayoutView( cityList: $cityList, saveAction: {})
                
        }
    }
    
    return previewView()
}
