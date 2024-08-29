//
//  SearchView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 28/08/24.
//

import SwiftUI

struct SearchView: View {
    @Binding var currentWeather: ForecastList?
    @Binding var cityList: [ForecastList]
    
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
                            currentWeather = await ApiHandling().getForecast(for: "\(result.title), \(result.subtitle)", type: "weather")
                            withAnimation(.easeIn) {
                                cityList.append(currentWeather!)
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
        @State var currentWeather: ForecastList? = nil
        @State var cityList: [ForecastList] = []
        @State private var searchVw = LocationSearchService()
        
        var body: some View {
            SearchView(currentWeather: $currentWeather, cityList: $cityList, searchVw: searchVw)
                .task {
                    do {
                        currentWeather = try await ApiHandling().getJson(endpoint: "https://api.openweathermap.org/data/2.5/weather?lat=-25.4371499&lon=-49.347251&appid=\(API_KEY)&units=metric", strategy: .convertFromSnakeCase)
                        
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
        }
    }
    
    return previewView()
}
