//
//  OverpassData.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/27/24.
//

import Foundation
import CoreLocation
import SwiftOverpassAPI
import MapKit
import Contacts

///filter for amenity|aeroway|aerialway|building|emergency|healthcare|man_made|military|office|natrual|public_transport|sport|water|railway|shop|tourism|leisure|historic

class OverpassData {
//    static let endpoint = "https://overpass-api.de"
//    
    var id: String
    var tags: [String : String]
    
    var name: String {
        get {
            tags["name"] ?? id
        }
    };
    
//    var address: CNPostalAddress {
//        get {
//            var address = CNPostalAddress();
//            address.street = ""
//        }
//    }
    
    var center: CLLocationCoordinate2D
//    var poiType:
    
    var parent: OverpassData?
    
    var mapItem: MKMapItem {
        get {
            let e = MKMapItem(placemark: MKPlacemark(coordinate: center))
            e.name = name
            return e;
        }
    }
    
//    var
    
    init(id: String, tags: [String : String], center:CLLocationCoordinate2D, parent: OverpassData? = nil) {
        self.id = id
        self.tags = tags
        self.center = center
//        self.name = name
        self.parent = parent
    }
    
//    static func sortByFavorite(center: CLLocationCoordinate2D, elements: [Int: OPElement]) -> [OverpassData] {
//        /// remove parking lots
//        var filteredElements = elements.filter { dict in
//            dict.value.tags.first { dict in
//                return dict.value.range(of: "parking") != nil
//            } == nil
//            
//        }
//        
//        ///Define Best:
//        ///We want the closest point to the selected point to be preferred
//        ///if two points are close to each other we want the one that has more complete data (like a name, an address) to be preferred
//        ///if the prefered point is inside any other points, we should attach the parent points to the best Point.
//        
//        
//        for element in filteredElements {
//            switch element.value.geometry {
//                
//            case .center(let centerCoordinates):
//                <#code#>
//            case .polyline(let lineCoordinates):
//                <#code#>
//            case .polygon(let polygonCoordinates):
//                <#code#>
//            case .multiPolygon(let nestedPolygonCoordinates):
//                <#code#>
//            case .multiPolyline(let nestedPollineCoordinates):
//                <#code#>
//            case .none:
//                <#code#>
//            }
//        }
//        
//    }
    
    static func sortByFavorite(center: CLLocationCoordinate2D, elements: [Int: OPElement]) -> [OverpassData] {
         // Filter out elements tagged as parking
         let filteredElements = elements.filter { _, element in
             element.tags.first { dict in
                return dict.value.range(of: "parking") != nil
             } == nil
         }
         
         // Convert to OverpassData for further processing
         let overpassDataElements = filteredElements.map { _, element -> OverpassData in
             // Assuming a simple case where OPElement has a center geometry
             switch element.geometry {
             case .center(let centerCoordinates):
                 return OverpassData(id: String(element.id), tags: element.tags, center: centerCoordinates)
             default:
                 // Handle other geometry types as needed
                 return OverpassData(id: String(element.id), tags: element.tags, center: center) // Placeholder for other cases
             }
         }
         
         // Sort by proximity and completeness of data
         return overpassDataElements.sorted { first, second in
             let distanceFirst = distance(from: first.center, to: center)
             let distanceSecond = distance(from: second.center, to: center)
             
             if distanceFirst != distanceSecond {
                 return distanceFirst < distanceSecond
             } else {
                 // If distances are equal, prefer elements with more complete data (e.g., name, address)
                 let completenessFirst = first.name != nil
                 let completenessSecond = second.name != nil
                 return completenessFirst && !completenessSecond
             }
         }
     }
     
     // Helper function to calculate distance between two CLLocationCoordinate2D points
     static private func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
         let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
         let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
         return fromLocation.distance(from: toLocation)
     }
    
    
    static func geocode(center: CLLocationCoordinate2D, radius: Double = 50) async throws -> [OverpassData] {

        let queryRegion = MKCoordinateRegion(
            center: center,
            latitudinalMeters: radius,
            longitudinalMeters: radius)
        let boundingBox = OPBoundingBox(region: queryRegion)
        
//        do {
//
//        } catch {
//            throw error
//        }

        let client = OPClient()
        client.endpoint = .kumiSystems

        
        return try await withCheckedThrowingContinuation({
            (continuation: CheckedContinuation<[OverpassData], Error>) in
            do {
                let query = try OPQueryBuilder()
                    .setTimeOut(180) //1
                    .setElementTypes([.node, .way, .relation]) //2
                //                .addTagFilter(key: "network", value: "BART", exactMatch: false) //3
                //                .addTagFilter(key: "type", value: "route") //4
//                    .addTagFilter(key: "amenity")
                    .addTagFilter(key: "~\"^(amenity|aeroway|aerialway|building|emergency|healthcare|man_made|military|office|natrual|public_transport|sport|water|railway|shop|tourism|leisure|historic)$\"~\".\"")
                    
//                    .addTagFilter(key: "amenity!", value: "parking")
                    .setBoundingBox(boundingBox)
                    .setOutputType(.center )
                    .buildQueryString()
//                print(query[0].)
                
                client.fetchElements(query: query) { result in
                    switch result {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                        
                    case .success(let elements):
//                        print(elements) // Do something with returned the elements
//                        elements.
                        continuation.resume(returning: sortByFavorite(center: center, elements: elements))
                        //                        continuation.resume(returning: image)

                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }

            
        })

    }
}
