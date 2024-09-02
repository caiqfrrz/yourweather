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
    
    // Saves the index to use in navigation
    @State var index: Int = 0
    
    @State private var isCityTapped = false
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        if cityList.list.isEmpty {
            emptyListView()
        } else {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(cityList.list) { city in
                        GridCitySquareView(weather: city)
                            .onTapGesture {
                                if let indexCity = cityList.getIndex(city) {
                                    index = indexCity
                                    isCityTapped = true
                                }
                            }
                            .onLongPressGesture(perform: {
                                index = 0
                                withAnimation {
                                    cityList.removeCity(city)
                                }
                            })
                            .sensoryFeedback(.start, trigger: isCityTapped)
                    }
                }
            }
            .navigationDestination(isPresented: $isCityTapped, destination: { CurrentWeatherView(weatherData: cityList.list[index])})
            .task {
                await cityList.updateList()
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .inactive { saveAction() }
            }
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
