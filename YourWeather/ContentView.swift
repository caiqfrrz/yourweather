//
//  ContentView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 23/08/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {

    @State private var searchVw = LocationSearchService()
    @State private var cityList: [WeatherData] = []
    
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
            
        }
    }
}

#Preview {
    ContentView()
}
