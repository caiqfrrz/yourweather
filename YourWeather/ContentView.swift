//
//  ContentView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 23/08/24.
//

import SwiftUI

struct ContentView: View {
    
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var searchVw = LocationSearchService()
    @State private var cityList = CityList.shared
    // Boolean to make sure the app only loads the saved list one time, and not when it comes back to this view
    @State private var hasLoaded = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !searchVw.results.isEmpty {
                    SearchView(cityList: $cityList, searchVw: searchVw)
                } else {
                    GridLayoutView(cityList: $cityList) {
                        Task {
                            do {
                                try await cityList.save(list: cityList.list)
                            } catch {
                                print("Error saving list: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchVw.query)
            .navigationTitle("YourWeather")
            .onAppear {
                if !hasLoaded {
                    Task {
                        do {
                            try await cityList.load()
                            hasLoaded = true  // Mark as loaded
                        } catch {
                            print("Error loading list: \(error.localizedDescription)")
                        }
                    }
                }
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    Task {
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
