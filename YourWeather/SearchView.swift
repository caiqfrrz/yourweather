//
//  SearchView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 28/08/24.
//

import SwiftUI

struct SearchView: View {
    @Binding var cityList: CityList
    
    var searchVw: LocationSearchService
    
    var body: some View {
        VStack {
            List(searchVw.results) { result in
                HStack {
                    VStack(alignment: .leading) {
                        Text(result.title)
                            .foregroundStyle(.white)
                        Text(result.subtitle)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            if let tempWeather: WeatherData = await ApiHandling().getWeatherData(for: "\(result.title), \(result.subtitle)") {
                                withAnimation(.easeIn) {
                                    cityList.addCity(tempWeather)
                                }
                            } else {
                                print("Failed to add city to list")
                            }
                        }
                        searchVw.emptyQuery()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            
        }
    }
}

#Preview {
    struct previewView: View {
        @State var cityList = CityList.shared
        @State private var searchVw = LocationSearchService()
        
        var body: some View {
            SearchView(cityList: $cityList, searchVw: searchVw)
        }
    }
    
    return previewView()
}
