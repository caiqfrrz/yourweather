//
//  LocationSearchService.swift
//  YourWeather
//
//  Created by Caique Ferraz on 28/08/24.
//

import Foundation
import SwiftUI
import MapKit

// Search service and autocompletion

@Observable
class LocationSearchService: NSObject {
     
    var query: String = "" {
        didSet {
            handleSearchFragment(query)
        }
    }
    var results: [LocationResult] = []
    var status: SearchStatus = .idle
    var completer: MKLocalSearchCompleter
    
    init(filter: MKPointOfInterestFilter = .includingAll,
         region: MKCoordinateRegion = MKCoordinateRegion(.world),
         types: MKLocalSearchCompleter.ResultType = [.address]) {
        
        completer = MKLocalSearchCompleter()
        
        super.init()
        
        completer.delegate = self
        completer.region = region
        completer.pointOfInterestFilter = filter
        completer.resultTypes = types
    }
    
    private func handleSearchFragment(_ fragment: String) {
        self.status = .searching
        
        if !fragment.isEmpty {
            self.completer.queryFragment = fragment
        } else {
            self.status = .idle
            self.results = []
        }
    }
    
    func emptyQuery() {
        withAnimation {
            query = ""
        }
    }
}

extension LocationSearchService: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        self.results = completer.results.map({ result in
            return LocationResult(title: result.title, subtitle: result.subtitle)
        })
        
        self.status = .result
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        self.status = .error(error.localizedDescription)
    }
    
}

struct LocationResult: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var subtitle: String
}

enum SearchStatus: Equatable {
    case idle
    case searching
    case error(String)
    case result
}
