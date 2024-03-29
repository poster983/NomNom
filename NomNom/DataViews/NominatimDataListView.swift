//
//  OSMDataView.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/25/24.
//

import SwiftUI





struct NominatimDataListView: View {
    @Binding var place: NominatimPlace?;
    var body: some View {
        if(place == nil) {
            EmptyView()
        } else {
                
                
//                List {
                    Section(header: Text("Info")) {
                        CopyableItem(title: "Name", text: place!.name)
                        CopyableItem(title: "Full Name", text: place!.displayName)
                    }
                    
                    Section(header: Text("Place")) {
                        CopyableItem(title: "Category", text: place!.category)
                        CopyableItem(title: "Address type", text: place!.addresstype)
                        CopyableItem(title: "Type", text: place!.type)
                        CopyableItem(title: "Place ID", text: String(place!.placeID ?? -1))
                        CopyableItem(title: "Place Rank", text: String(place!.placeRank ?? -1))
                        CopyableItem(title: "Importance", text: String(place!.importance ?? -1))
                                            
                    }
                    
                    Section(header: Text("Address")) {
                        
                        CopyableItem(title: "Shop", text: place!.address?.shop)
                        CopyableItem(title: "House", text: place!.address?.houseNumber)
                        CopyableItem(title: "Road", text: place!.address?.road)
                        CopyableItem(title: "City", text: place!.address?.city)
                        CopyableItem(title: "State", text: place!.address?.state)
                        CopyableItem(title: "Post Code", text: place!.address?.postcode)
                        CopyableItem(title: "Country", text: place!.address?.country)
                    }
                    
                    Section(header: Text("Earth")) {
                        
                        CopyableItem(title: "Latitude", text: place!.lat)
                        CopyableItem(title: "Longitude", text: place!.lon)
                        
                    }
                    
                    Section(header: Text("Open Street Map")) {
                        CopyableItem(title: "OSM Type", text: place?.osmType)
                        Link("OSM ID: \(place!.osmID ?? -1)", destination: URL(string: "https://www.openstreetmap.org/\(place?.osmType ?? "")/\(place!.osmID ?? -1)")!)
                        Link("Server: nominatim.openstreetmap.org", destination: URL(string: "https://nominatim.openstreetmap.org/")!)
                        if(place!.licence != nil) {
                            Text(place!.licence!)
                        }
                    }
                    
                    
                    
                }

                
                
            
//        }
    }
}




//#Preview {
//    
//    OSMDataView(place: OSMPlace(placeID: 0000, licence: None, osmType: "Type", osmID: 123, lat: <#T##String?#>, lon: <#T##String?#>, category: <#T##String?#>, type: <#T##String?#>, placeRank: <#T##Int?#>, importance: <#T##Double?#>, addresstype: <#T##String?#>, name: <#T##String?#>, displayName: <#T##String?#>, address: <#T##Address?#>, boundingbox: <#T##[String]?#>))
//}
