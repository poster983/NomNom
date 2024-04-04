//
//  OverpassData.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/27/24.
//
//
//import Foundation
//import CoreLocation
//import SwiftOverpassAPI
//import MapKit
//import Contacts
//
/////filter for amenity|aeroway|aerialway|building|emergency|healthcare|man_made|military|office|natrual|public_transport|sport|water|railway|shop|tourism|leisure|historic
//
//class OverpassData {
////    static let endpoint = "https://overpass-api.de"
////    
//    var id: String
//    var tags: [String : String]
//    
//    var name: String {
//        get {
//            tags["name"] ?? id
//        }
//    };
//    
////    var address: CNPostalAddress {
////        get {
////            var address = CNPostalAddress();
////            address.street = ""
////        }
////    }
//    
//    var center: CLLocationCoordinate2D
//    var area: [CLLocationCoordinate2D] = []
////    var poiType:
//    
//    var parent: OverpassData?
//    
//    var mapItem: MKMapItem {
//        get {
//            let e = MKMapItem(placemark: MKPlacemark(coordinate: center))
//            e.name = name
//            if(!area.isEmpty) {
//                e.name! += " (Area)"
//            }
////            e.pointOfInterestCategory = MKPointOfInterestCategory.
//            
//            return e;
//        }
//    }
//    var mapBoundingBox: [MKMapPoint] {
//        get {
//            return area.map {point in
//                MKMapPoint(point)
//            }
//        }
//    }
//    
//    
//    init(id: String, tags: [String : String], center:CLLocationCoordinate2D, parent: OverpassData? = nil, area: [CLLocationCoordinate2D] = []) {
//        self.id = id
//        self.tags = tags
//        self.center = center
//        self.parent = parent
//        self.area = area
//    }
//    
//
//    
//    static func sortByFavorite(center: CLLocationCoordinate2D, elements: [Int: OPElement]) -> [OverpassData] {
//        ///Define Best:
//        //        ///We want the closest point to the selected point to be preferred
//        //        ///if two points are close to each other we want the one that has more complete data (like a name, an address) to be preferred
//        //        ///if the prefered point is inside any other points, we should attach the parent points to the best Point.
//         // Filter out elements tagged as parking
//         let filteredElements = elements.filter { _, element in
////             element.tags.first { dict in
////                return dict.value.range(of: "parking") != nil
////             } == nil
//             return element.tags["amenity"]?.range(of: "parking") == nil
//         }
//         
//         // Convert to OverpassData for further processing
//         let overpassDataElements = filteredElements.map { _, element -> OverpassData in
//             // Assuming a simple case where OPElement has a center geometry
//             switch element.geometry {
//             case .center(let centerCoordinates):
//                 return OverpassData(id: String(element.id), tags: element.tags, center: centerCoordinates)
//             case .polygon(let area):
//                 return OverpassData(id: String(element.id), tags: element.tags, center: OverpassData.centroidOfPolygon(coordinates: area), area: area)
//             default:
////                 print(element.meta.)
//                 // Handle other geometry types as needed
//                 return OverpassData(id: String(element.id), tags: element.tags, center: center) // Placeholder for other cases
//             }
//         }
//         
//         // Sort by proximity and completeness of data
//         return overpassDataElements.sorted { first, second in
//             let distanceFirst = distance(from: first.center, to: center)
//             let distanceSecond = distance(from: second.center, to: center)
//             
//             if distanceFirst != distanceSecond {
//                 return distanceFirst < distanceSecond
//             } else {
//                 // If distances are equal, prefer elements with more complete data (e.g., name, address)
//                 let completenessFirst = first.name != nil
//                 let completenessSecond = second.name != nil
//                 return completenessFirst && !completenessSecond
//             }
//         }
//     }
//     
//     // Helper function to calculate distance between two CLLocationCoordinate2D points
//     static private func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
//         let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
//         let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
//         return fromLocation.distance(from: toLocation)
//     }
//    
//    /// Calculate the centroid of a polygon given its vertices.
//    /// - Parameter coordinates: An array of `CLLocationCoordinate2D` representing the polygon vertices.
//    /// - Returns: The `CLLocationCoordinate2D` representing the centroid of the polygon.
//    static func centroidOfPolygon(coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
//        // Ensure there are coordinates to avoid division by zero
//        guard !coordinates.isEmpty else {
//            return CLLocationCoordinate2D()
//        }
//        
//        // Sum up all the latitude and longitude values
//        let sum = coordinates.reduce((lat: 0.0, lon: 0.0)) { (result, coordinate) -> (lat: Double, lon: Double) in
//            return (result.lat + coordinate.latitude, result.lon + coordinate.longitude)
//        }
//        
//        // Calculate the average latitude and longitude
//        let averageLat = sum.lat / Double(coordinates.count)
//        let averageLon = sum.lon / Double(coordinates.count)
//        
//        // Return the centroid coordinate
//        return CLLocationCoordinate2D(latitude: averageLat, longitude: averageLon)
//    }
//    
//    
//    static func geocode(center: CLLocationCoordinate2D, radius: Double = 50) async throws -> [OverpassData] {
//
//        let queryRegion = MKCoordinateRegion(
//            center: center,
//            latitudinalMeters: radius,
//            longitudinalMeters: radius)
//        let boundingBox = OPBoundingBox(region: queryRegion)
//        
////        do {
////
////        } catch {
////            throw error
////        }
//
//        let client = OPClient()
//        client.endpoint = .kumiSystems
//
//        
//        return try await withCheckedThrowingContinuation({
//            (continuation: CheckedContinuation<[OverpassData], Error>) in
//            do {
//                let query = try OPQueryBuilder()
//                    .setTimeOut(180) //1
//                    .setElementTypes([.node, .way, .relation]) //2
//                //                .addTagFilter(key: "network", value: "BART", exactMatch: false) //3
//                //                .addTagFilter(key: "type", value: "route") //4
////                    .addTagFilter(key: "amenity")
//                    .addTagFilter(key: "~\"^(amenity|aeroway|aerialway|building|emergency|healthcare|man_made|military|office|natrual|public_transport|sport|water|railway|shop|tourism|leisure|historic)$\"~\".\"")
//                    
////                    .addTagFilter(key: "amenity!", value: "parking")
//                    .setBoundingBox(boundingBox)
//                    
//                    .setOutputType(.geometry )
//                    .buildQueryString()
////                print(query[0].)
//                
//                client.fetchElements(query: query) { result in
//                    switch result {
//                    case .failure(let error):
//                        continuation.resume(throwing: error)
//                        
//                    case .success(let elements):
////                        print(elements) // Do something with returned the elements
////                        elements.
//                        continuation.resume(returning: sortByFavorite(center: center, elements: elements))
//                        //                        continuation.resume(returning: image)
//
//                    }
//                }
//            } catch {
//                continuation.resume(throwing: error)
//            }
//
//            
//        })
//
//    }
//}


import Foundation
import CoreLocation
import SwiftOverpassAPI
import MapKit

/// Represents data from the Overpass API as a Swift class.
class OverpassData {
    // MARK: - Properties
    var id: String
    var tags: [String: String]
    var center: CLLocationCoordinate2D
    var area: [CLLocationCoordinate2D] = []
    var parent: OverpassData?
    var type: String?
    
    // Computed property to get the name of the data point.
    var name: String? {
        tags["name"]
    }

    
    // Computed property to get an MKMapItem for use with MapKit.
    var mapItem: MKMapItem {
        let placemark = MKPlacemark(coordinate: center)
        let item = MKMapItem(placemark: placemark)
        item.name = (name ?? "ID: \(id)") + " \(type ?? "")"
//        if(!area.isEmpty) {
//            item.name = item.name! + " (Area)"
//        }
        return item
    }
    
    var mapBoundingBox: [MKMapPoint] {
        get {
            return area.map(MKMapPoint.init)
        }
    }
    
    // MARK: - Initialization
    init(id: String, tags: [String: String], center: CLLocationCoordinate2D, parent: OverpassData? = nil, area: [CLLocationCoordinate2D] = [], type: String? = nil) {
        self.id = id
        self.tags = tags
        self.center = center
        self.parent = parent
        self.type = type
        self.area = area
    }
    
    // MARK: - Public Methods
    /// Fetches Overpass API data and converts it into OverpassData objects.
    static func fetchOverpassData(center: CLLocationCoordinate2D, radius: Double = 50) async throws -> [OverpassData] {
        // Prepare the bounding box based on center and radius
        let queryRegion = MKCoordinateRegion(center: center, latitudinalMeters: radius, longitudinalMeters: radius)
        let boundingBox = OPBoundingBox(region: queryRegion)
        
        let client = OPClient()
        client.endpoint = .kumiSystems // An example Overpass API endpoint
        
        let query = try OPQueryBuilder()
            .setTimeOut(180)
            .setElementTypes([.node, .way, .relation])
            .addTagFilter(key: "~\"^(amenity|aeroway|aerialway|building|emergency|healthcare|man_made|military|office|natrual|public_transport|sport|water|railway|shop|tourism|leisure|historic)$\"~\".\"")
            .setBoundingBox(boundingBox)
            .setOutputType(.geometry)
            .buildQueryString()
        
        return try await withCheckedThrowingContinuation { continuation in
            client.fetchElements(query: query) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let elements):
                    let overpassData = elements.compactMap { convertToOverpassData($1) }
                    let sortedData = sortByFavorite(center: center, data: overpassData)
                    continuation.resume(returning: sortedData)
                }
            }
        }
    }
    
    /// Sorts an array of OverpassData based on proximity to a specified center and data completeness.
    static func sortByFavorite(center: CLLocationCoordinate2D, data: [OverpassData]) -> [OverpassData] {
        return data.sorted { first, second in
            // Check for parking amenity tag to prioritize non-parking elements
            let isParkingFirst = first.tags["amenity"] == "parking"
            let isParkingSecond = second.tags["amenity"] == "parking"
            
            if isParkingFirst != isParkingSecond {
                // If only one of the elements is parking, the non-parking one should come first
                return isParkingSecond
            }

            // Calculate distance from the center for both elements
            let distanceFirst = distance(from: first.center, to: center)
            let distanceSecond = distance(from: second.center, to: center)

            // If distances are different, sort by distance
            if distanceFirst != distanceSecond {
                return distanceFirst < distanceSecond
            } else {
                // If distances are equal, prefer elements with more complete data
                // Assuming 'name' presence as an indicator of data completeness
                let completenessFirst = first.name != "Unnamed"
                let completenessSecond = second.name != "Unnamed"
                return completenessFirst && !completenessSecond
            }
        }
    }

    
    // MARK: - Private Helper Methods
    private static func convertToOverpassData(_ element: OPElement) -> OverpassData? {
        switch element.geometry {
        case .center(let centerCoordinates):
            return OverpassData(id: String(element.id), tags: element.tags, center: centerCoordinates, type: "point")
        case .polygon(let areaCoordinates):
            let centroid = centroidOfPolygon(coordinates: areaCoordinates)
            return OverpassData(id: String(element.id), tags: element.tags, center: centroid, area: areaCoordinates, type: "polygon")
        case .polyline(let line):
            let centroid = centroidOfPolygon(coordinates: line)
            return OverpassData(id: String(element.id), tags: element.tags, center: centroid, type: "polyline")
        default:
            return nil
        }
    }
    
    /// Calculates the centroid of a polygon given its vertices.
    private static func centroidOfPolygon(coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        guard !coordinates.isEmpty else { return CLLocationCoordinate2D() }
        let sum = coordinates.reduce((lat: 0.0, lon: 0.0)) { (result, coordinate) in
            (result.lat + coordinate.latitude, result.lon + coordinate.longitude)
        }
        return CLLocationCoordinate2D(latitude: sum.lat / Double(coordinates.count), longitude: sum.lon / Double(coordinates.count))
    }
    
    /// Calculates the distance between two CLLocationCoordinate2D points.
    private static func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        CLLocation(latitude: from.latitude, longitude: from.longitude).distance(from: CLLocation(latitude: to.latitude, longitude: to.longitude))
    }
}
