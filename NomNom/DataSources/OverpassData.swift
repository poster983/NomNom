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

///filter for amenity|aeroway|aerialway|building|emergency|healthcare|man_made|military|office|natrual|public_transport|sport|water|railway|shop|tourism|leisure|historic



struct OverpassData {
//    static let endpoint = "https://overpass-api.de"
//    
//    var id: String
//    var tags: [String : String]
    
    static func geocode(center: CLLocationCoordinate2D, radius: Double = 50) async throws -> [Int: OPElement] {

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
            (continuation: CheckedContinuation<[Int: OPElement], Error>) in
            do {
                let query = try OPQueryBuilder()
                    .setTimeOut(180) //1
                    .setElementTypes([.node, .way, .relation]) //2
                //                .addTagFilter(key: "network", value: "BART", exactMatch: false) //3
                //                .addTagFilter(key: "type", value: "route") //4
//                    .addTagFilter(key: "amenity")
                    .addTagFilter(key: "~\"^(amenity|aeroway|aerialway|building|emergency|healthcare|man_made|military|office|natrual|public_transport|sport|water|railway|shop|tourism|leisure|historic)$\"~\".\"")
                    
                //                .addTagFilter(key: "aerialway")
                    .setBoundingBox(boundingBox)
                    .setOutputType(.center)
                    .buildQueryString()
                print(query)
                
                client.fetchElements(query: query) { result in
                    switch result {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                        
                    case .success(let elements):
//                        print(elements) // Do something with returned the elements
//                        elements.
                        continuation.resume(returning: elements)
                        //                        continuation.resume(returning: image)

                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }

            
        })

    }
}
