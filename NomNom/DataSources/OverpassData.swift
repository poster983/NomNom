//
//  OverpassData.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/27/24.
//
//
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
    ///Calculates the area of the area bounding box
    func calculateArea() -> Double {
        let vertices = area
        guard vertices.count >= 3 else {
            // Not a polygon if there are fewer than 3 vertices
            return 0.0
        }

        var sum1 = 0.0
        var sum2 = 0.0

        // Iterate over the vertices to compute the sums
        for i in 0..<vertices.count - 1 {
            sum1 += vertices[i].latitude * vertices[i + 1].longitude
            sum2 += vertices[i].longitude * vertices[i + 1].latitude
        }

        // Closing the polygon by considering the edge from the last vertex to the first
        sum1 += vertices[vertices.count - 1].latitude * vertices[0].longitude
        sum2 += vertices[vertices.count - 1].longitude * vertices[0].latitude

        // Calculate and return the absolute value of half the difference of the sums
        return 0.5 * abs(sum1 - sum2)
    }
    
    ///Calculates if the given point is inside the arrea of this location
    // Determine if a point is inside the polygon defined by the area property
    func isPointInArea(_ point: CLLocationCoordinate2D) -> Bool {
        let testX = point.latitude
        let testY = point.longitude
        var isInside = false
        var j = area.count - 1
        
        for i in 0..<area.count {
            let xi = area[i].latitude, yi = area[i].longitude
            let xj = area[j].latitude, yj = area[j].longitude
            
            let intersect = ((yi > testY) != (yj > testY)) &&
                (testX < (xj - xi) * (testY - yi) / (yj - yi) + xi)
            if intersect {
                isInside = !isInside
            }
            
            j = i
        }
        
        return isInside
    }


    ///Takes a list of overpass data classes and finds parents for each of the points if any
    static func findParents(with inputData: [OverpassData]) -> [OverpassData] {
        var transformedData = inputData
        
        for i in 0..<transformedData.count {
            var smallestAreaParent: (index: Int, area: Double) = (-1, Double.greatestFiniteMagnitude)
            let childArea = transformedData[i].calculateArea() // Calculate child's area
            
            for j in 0..<inputData.count {
                if i != j {
                    let point = transformedData[i].center
                    if inputData[j].isPointInArea(point) {
                        let potentialParentArea = inputData[j].calculateArea()
                        // Ensure the potential parent's area is larger than the child's area
                        if potentialParentArea > childArea && potentialParentArea < smallestAreaParent.area {
                            smallestAreaParent = (j, potentialParentArea)
                        }
                    }
                }
            }
            
            // Assign the smallest valid parent
            if smallestAreaParent.index != -1 {
                transformedData[i].parent = inputData[smallestAreaParent.index]
            }
        }
        
        return transformedData
    }


    
    /// Fetches Overpass API data and converts it into OverpassData objects.
    static func fetchOverpassData(center: CLLocationCoordinate2D, radius: Double = 50) async throws -> [OverpassData] {
        // Prepare the bounding box based on center and radius
        let queryRegion = MKCoordinateRegion(center: center, latitudinalMeters: radius, longitudinalMeters: radius)
        let boundingBox = OPBoundingBox(region: queryRegion)
        
        let client = OPClient()
        client.endpoint = .main // An example Overpass API endpoint
        ///Old query Builder
//        let query = try OPQueryBuilder()
//            .setTimeOut(180)
//            .setElementTypes([.node, .way, .relation])
//            .addTagFilter(key: "~\"^(amenity|aeroway|aerialway|building|emergency|healthcare|man_made|military|office|public_transport|sport|water|railway|shop|tourism|leisure|historic)$\"~\".\"")
//            .setBoundingBox(boundingBox)
//            .setOutputType(.geometry)
//            .buildQueryString()
        let coordString = "\(center.latitude),\(center.longitude)"
        let tagFilters = "[~\"^(amenity|aeroway|aerialway|building|emergency|healthcare|man_made|military|office|public_transport|sport|water|railway|shop|tourism|leisure|historic)$\"~\".\"]";
        let query = """
[out:json][timeout:180];
(
// Existing features within bounding box
node\(tagFilters)(around:\(radius),\(coordString));
rel\(tagFilters)(around:\(radius),\(coordString));
way\(tagFilters)(around:\(radius),\(coordString));
          
          
is_in(\(coordString))->.a;
way\(tagFilters)(pivot.a);
//relation(pivot.a);
);
        // Output the results
//out body;
//>;
//out skel qt;
out geom;
"""
        print(query)
        return try await withCheckedThrowingContinuation { continuation in
            client.fetchElements(query: query) { result in
                
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let elements):
                    print("Yay!")
                    let overpassData = elements.compactMap { convertToOverpassData($1) }
                    let sortedData = sortByFavorite(center: center, data: overpassData)
                    let withParents = findParents(with: sortedData)
                    continuation.resume(returning: withParents)
                }
            }
        }
    }
    
    /// Sorts an array of OverpassData based on proximity to a specified center and data completeness.
    static func sortByFavorite(center: CLLocationCoordinate2D, data: [OverpassData]) -> [OverpassData] {
        return data.sorted { first, second in
            // Check for parking amenity tag to prioritize non-parking elements
            let isParkingFirst = first.tags["amenity"]?.ranges(of: "parking") != nil
            let isParkingSecond = second.tags["amenity"]?.ranges(of: "parking") != nil
            
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
                //base this off of how many tags each one has
                return first.tags.count > second.tags.count

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
        case .multiPolygon(let nested):
            ///find the set of coordinates that has the greatest length
            var best: [CLLocationCoordinate2D] = [];
            for cSet in nested {
                if(best.count < cSet.outerRing.count) {
                    best = cSet.outerRing;
                }
            }
            let centroid = centroidOfPolygon(coordinates: best)
            return OverpassData(id: String(element.id), tags: element.tags, center: centroid, area: best, type: "multipolygon")
            
                        
        default:
            print("Filtering out \(element)")
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
