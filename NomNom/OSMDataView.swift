//
//  OSMDataView.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/25/24.
//

import SwiftUI

struct OSMPlace: Codable {
    let placeID: Int?
    let licence, osmType: String?
    let osmID: Int?
    let lat, lon, category, type: String?
    let placeRank: Int?
    let importance: Double?
    let addresstype, name, displayName: String?
    let address: Address?
    let boundingbox: [String]?

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


}

struct Address: Codable {
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



struct OSMDataView: View {
    @Binding var place: OSMPlace?;
    var body: some View {
        if(place == nil) {
            EmptyView()
        } else {
            Group {
                
                
                List {
                    
                    Text("Name: \(place!.name ?? "")")
                    
                    Section(header: Text("Place")) {
                        Text("Catagory: \(place!.category ?? "")")
                        Text("Address type: \(place!.addresstype ?? "")")
                        Text("Type: \(place!.type ?? "")")
                        Text("Place ID: \(place?.placeID ?? -1)")
                        Text("Place Rank: \(place?.placeRank ?? -1)")
                        Text("Place Importance: \(place?.importance ?? -1)")
                        
                    }
                    
                    Section(header: Text("Address")) {
                        Text("Address: \(place!.address?.houseNumber ?? "") \(place!.address?.road ?? "")")
                        Text("City: \(place!.address?.city ?? "")")
                        Text("State: \(place!.address?.state ?? "")")
                        Text("PostCode: \(place!.address?.postcode ?? "")")
                        Text("Country: \(place!.address?.country ?? "")")
                    }
                    
                    Section(header: Text("Open Street Map")) {
                        Text("OSM Type: \(place?.osmType ?? "")")
                        Link("OSM ID: \(place!.osmID ?? -1)", destination: URL(string: "https://www.openstreetmap.org/\(place?.osmType ?? "")/\(place!.osmID ?? -1)")!)
                        if(place!.licence != nil) {
                            Text(place!.licence!)
                        }
                    }
                    
                    
                    
                }
                #if !os(macOS)
                .listStyle(.insetGrouped)
                #else
                .listStyle(.automatic)
                #endif
                .background(.regularMaterial)
                
                
            }
        }
    }
}

//#Preview {
//    
//    OSMDataView(place: OSMPlace(placeID: 0000, licence: None, osmType: "Type", osmID: 123, lat: <#T##String?#>, lon: <#T##String?#>, category: <#T##String?#>, type: <#T##String?#>, placeRank: <#T##Int?#>, importance: <#T##Double?#>, addresstype: <#T##String?#>, name: <#T##String?#>, displayName: <#T##String?#>, address: <#T##Address?#>, boundingbox: <#T##[String]?#>))
//}
