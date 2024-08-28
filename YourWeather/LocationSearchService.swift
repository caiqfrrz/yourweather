//
//  LocationSearchService.swift
//  YourWeather
//
//  Created by Caique Ferraz on 28/08/24.
//

import Foundation
import MapKit

struct Coords: Hashable {
    var lat: Double = 0.0
    var lon: Double = 0.0
}

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
}

extension LocationSearchService: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let dispatchGroup = DispatchGroup()
                
                for result in completer.results {
                    dispatchGroup.enter()
                    getCoordinates(for: result) { coords in
                        let locationResult = LocationResult(title: result.title, subtitle: result.subtitle, coord: coords)
                        self.results.append(locationResult)
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.status = .result
                }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        self.status = .error(error.localizedDescription)
    }
    
    private func getCoordinates(for completion: MKLocalSearchCompletion, completionHandler: @escaping (Coords) -> Void) {
            let request = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: request)
            
            search.start { response, error in
                guard let response = response, let location = response.mapItems.first?.placemark.location else {
                    completionHandler(Coords())
                    return
                }
                
                let coords = Coords(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                completionHandler(coords)
            }
        }
}

struct LocationResult: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var subtitle: String
    var coord = Coords()
}

enum SearchStatus: Equatable {
    case idle
    case searching
    case error(String)
    case result
}
