//
//  AppleDataView.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/27/24.
//

import SwiftUI
import MapKit
struct AppleDataListView: View {
    @Binding var places: [MKMapItem];
    var body: some View {
        ForEach($places, id: \.self) { place in
            let p = { place.wrappedValue } ()
            let title = {
                
//                let pm = place.placemark.
                return (p.name
                        ?? p.placemark.name
                        ?? "\(p.placemark.coordinate.latitude), \(p.placemark.coordinate.longitude)")
            }();
                NavigationLink(destination: {
                    
                    Group {
                        List {
                            CopyableItem(title: "Name", text: p.name)
                            CopyableItem(title: "Subtitle", text: p.placemark.subtitle)
                            
                            Section(header: Text("Place")) {
//                                let category: String? = (place.pointOfInterestCategory == nil) ? nil : place.pointOfInterestCategory!.rawValue! as String;
//                                CopyableItem(title: "POI Category", text: category)
//                                CopyableItem(title: "POI Category", text: place.)
                                CopyableItem(title: "Time Zone", text: p.timeZone?.identifier)
                                
                                
                                
                            }
                            
                            Section(header: Text("Address")) {
//
//                                CopyableItem(title: "Postal Address", text: p.placemark.)
                                CopyableItem(title: "Thoroughfare", text: p.placemark.thoroughfare)
                                CopyableItem(title: "Sub-Thoroughfare", text: p.placemark.subThoroughfare)
                                CopyableItem(title: "Locality", text: p.placemark.locality)
                                CopyableItem(title: "Sub-Locality", text: p.placemark.subLocality)
                                CopyableItem(title: "Administrative Area", text: p.placemark.administrativeArea)
                                CopyableItem(title: "Sub-Administrative Area", text: p.placemark.subAdministrativeArea)
                                
                                CopyableItem(title: "Country", text: p.placemark.country)
                                CopyableItem(title: "Postal Code", text: p.placemark.postalCode)
                                
                                CopyableItem(title: "Inland Water", text: p.placemark.inlandWater)
                                CopyableItem(title: "Ocean", text: p.placemark.ocean)
                                
                            }
                            
                            Section(header: Text("Earth")) {
                                
                                CopyableItem(title: "Latitude", text: String(p.placemark.coordinate.latitude))
                                CopyableItem(title: "Longitude", text: String(p.placemark.coordinate.longitude))
                                
                            }
                        }
                    }.navigationTitle(title)
                    
                }) {
                    Text(title)
//                    HStack {
//                        Image(systemName: place.pointOfInterestCategory.)
//                        
//                    }
                }
        }
    }
}

#Preview {
    AppleDataListView(places: .constant([
    MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 32, longitude: -90)))
    ]))
}
