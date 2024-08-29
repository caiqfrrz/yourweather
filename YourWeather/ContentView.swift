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
    @State private var forecast: Forecast? = nil
    @State private var currentWeather: ForecastList? = nil
    
    @State private var cityList: [ForecastList] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !searchVw.results.isEmpty {
                    SearchView(currentWeather: $currentWeather, cityList: $cityList, searchVw: searchVw)
                } else {
                   GridLayoutView(currentWeather: $currentWeather, currentForecast: $forecast, cityList: $cityList)
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
