//
//  MapkitData.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/27/24.
//

import Foundation
import CoreLocation
import MapKit

struct AppleData {
    
    
    
    static func geocodeMapkit(tappedPlace: CLLocationCoordinate2D) async throws -> [MKMapItem] {
        var places: [MKMapItem] = []
        let ger = CLGeocoder()
        let loc = try! await ger.reverseGeocodeLocation(CLLocation(coordinate: tappedPlace, altitude: 0, horizontalAccuracy: 80, verticalAccuracy: 0, timestamp: Date()))
        
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = "\(loc[0].name ?? "") \(loc[0].thoroughfare ?? "") \(loc[0].locality ?? "")"
//        print(request.naturalLanguageQuery)
//            request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.bakery, .cafe, .restaurant])

        request.region = MKCoordinateRegion(center: tappedPlace, latitudinalMeters: 100, longitudinalMeters: 100)
        let search = MKLocalSearch(request: request)

        let result = try await search.start()
        for place in result.mapItems {
//            print(place.pointOfInterestCategory)
            places.append(place)
        }
        
        return places;

    }
    
    static func geocodeCoreLocation(tappedPlace: CLLocationCoordinate2D) async throws -> [MKMapItem] {
//        Task {
//            places.removeAll()
        var places: [MKMapItem] = []
            let ger = CLGeocoder()
            let loc = try! await ger.reverseGeocodeLocation(CLLocation(coordinate: tappedPlace, altitude: 0, horizontalAccuracy: 80, verticalAccuracy: 0, timestamp: Date()))
            print(loc)
            for place in loc {
//                        place.pointOfInterestCategory
                let item = MKMapItem(placemark: MKPlacemark(placemark: place))
//                print(item.pointOfInterestCategory)
                places.append(item)
            }
        return places

//        }
    }
}

