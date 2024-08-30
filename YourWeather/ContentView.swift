//
//  ContentView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 23/08/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {

    @Environment(\.scenePhase) private var scenePhase
    @State private var searchVw = LocationSearchService()
    @State private var cityList = CityList()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !searchVw.results.isEmpty {
                    SearchView(cityList: $cityList, searchVw: searchVw)
                } else {
                   GridLayoutView(cityList: $cityList)
                }
            }
            .searchable(text: $searchVw.query)
            .navigationTitle("YourWeather")
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
}

#Preview {
    ContentView()
}
