//
//  NominatimData.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/26/24.
//

import Foundation
import CoreLocation
import MapKit

struct NominatimPlace: Codable {
    let placeID: Int?
    let licence, osmType: String?
    let osmID: Int?
    let lat, lon, category, type: String?
    let placeRank: Int?
    let importance: Double?
    let addresstype, name, displayName: String?
    let address: NominatimAddress?
    let boundingbox: [String]?
    
    var  mapkitBoundBox: [MKMapPoint] {
        get {
            guard boundingbox != nil else {
                return []
            }
            guard boundingbox!.count == 4,
                  let southLat = Double(boundingbox![0]),
                  let northLat = Double(boundingbox![1]),
                  let westLon = Double(boundingbox![2]),
                  let eastLon = Double(boundingbox![3]) else {
                print("Invalid bounding box format")
                return []
            }

            // 2. Create MKMapPoints for each corner
            let bottomLeft = MKMapPoint(CLLocationCoordinate2D(latitude: southLat, longitude: westLon))
            let bottomRight = MKMapPoint(CLLocationCoordinate2D(latitude: southLat, longitude: eastLon))
            let topRight = MKMapPoint(CLLocationCoordinate2D(latitude: northLat, longitude: eastLon))
            let topLeft = MKMapPoint(CLLocationCoordinate2D(latitude: northLat, longitude: westLon))

            // 3. Return the array of points
            return [bottomLeft, bottomRight, topRight, topLeft]
        }
    }

    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
        case licence
        case osmType = "osm_type"
        case osmID = "osm_id"
        case lat, lon, category, type
        case placeRank = "place_rank"
        case importance, addresstype, name
        case displayName = "display_name"
        case address, boundingbox
    }

    ///Calls the Nominatim API to geocode the given coordinate
    static func geocode(coordinate: CLLocationCoordinate2D) async throws -> NominatimPlace {
        let url = URL(string: "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)")!
        //async call to the API
        let (data, _) = try await URLSession.shared.data(from: url)
        let str = String(decoding: data, as: UTF8.self)
        print(str)
        //decode the data
        let place = try JSONDecoder().decode(NominatimPlace.self, from: data)
        return place
    }
}

struct NominatimAddress: Codable {
    let shop, houseNumber, road, city: String?
    let county, state, iso31662Lvl4, postcode: String?
    let country, countryCode: String?

    enum CodingKeys: String, CodingKey {
        case shop
        case houseNumber = "house_number"
        case road, city, county, state
        case iso31662Lvl4 = "ISO3166-2-lvl4"
        case postcode, country
        case countryCode = "country_code"
    }
}
