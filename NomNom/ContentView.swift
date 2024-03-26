//
//  ContentView.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/25/24.
//

import SwiftUI
import MapKit

///https://wiki.openstreetmap.org/wiki/Map_features#Food,_beverages


struct ContentView: View {

    @State var selectedPlace: OSMPlace?
    @State var selectedItem: MKMapItem?
    @State var boundingBox: [MKMapPoint] = []
//    @State var isHorizontal: Bool;
    var body: some View {
        
        GeometryReader{ geomReader in
            var isHorizontal = geomReader.size.height < geomReader.size.width
//            let layout = isHorizontal ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
            
            let content = MapReader{ reader in
                
                Map{
                    if(selectedItem != nil) {
                        Marker(item:selectedItem!)
                    }
                    if(boundingBox.count > 0) {
                        MapPolygon(points: boundingBox)
                            .foregroundStyle(.red.opacity(0.60))
                    }
                    
                }
                .coordinateSpace(.named("map"))
                .onTapGesture(perform: { screenCoord in
                    let pin = reader.convert(screenCoord, from: .local)
                    
                    print(pin)
                    print("h: \(geomReader.size.height) | w: \(geomReader.size.width)")
                    Task {
                        do {
                            let place = try await geocodeOpenStreetMap(coordinate: pin!)
                            if(place.lat == nil || place.lon == nil) {
                                selectedPlace = nil;
                                selectedItem = nil;
                                boundingBox.removeAll()
                                return;
                                
                            }
                            selectedPlace = place
                            
                            //placemark MKItem
                            selectedItem = MKMapItem(placemark: MKPlacemark(
                                
                                coordinate: CLLocationCoordinate2D(latitude: Double(place.lat!)!, longitude: Double(place.lon!)!)))
                            selectedItem!.name = place.displayName
                            
                            //polyline
                            
                            boundingBox.removeAll()
                            if(place.boundingbox != nil) {
                                boundingBox = convertOSMBoundingBox(components: place.boundingbox!)
                            }
                            
                            
                            
                        } catch {
                            print(error)
                            return;
                        }
                    }
                })
//                .safeAreaInset(edge: .bottom) {
//                    if(!isHorizontal) {
//                        
//                        OSMDataView(place: $selectedPlace)
//                            .frame( height: !isHorizontal ?
//                                    geomReader.size.height/2
//                                    :   geomReader.size.width/2
//                                    
//                            )
//                            
//                            
//                        
//                    }
//                }
                
            }
            #if os(macOS)
            if(isHorizontal) {
                HSplitView {
                    content
                    OSMDataView(place: $selectedPlace)
                       
                }
                
            } else {
                VSplitView {
                    content
                    OSMDataView(place: $selectedPlace)
//                        .frame( height: geomReader.size.height/2)
                }
            }
            #else
            if(isHorizontal) {
                HStack {
                    content
                    OSMDataView(place: $selectedPlace)
                        .frame( width: geomReader.size.width/2)
                       
                }
                
            } else {
                VStack {
                    content
                    OSMDataView(place: $selectedPlace)
                        .frame( height: geomReader.size.height/2)
//                        .frame( height: geomReader.size.height/2)
                }
            }
            #endif
//            content
            
        }
    }
    
    ///Calls the Nominatim API to geocode the given coordinate
    func geocodeOpenStreetMap(coordinate: CLLocationCoordinate2D) async throws -> OSMPlace {
        let url = URL(string: "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)")!
        //async call to the API
        let (data, _) = try await URLSession.shared.data(from: url)
        let str = String(decoding: data, as: UTF8.self)
        print(str)
        //decode the data
        let place = try JSONDecoder().decode(OSMPlace.self, from: data)
        return place

        
    }
    
    func convertOSMBoundingBox(components: [String]) -> [MKMapPoint] {
        // 1. Split the bounding box string into components

        guard components.count == 4,
              let southLat = Double(components[0]),
              let northLat = Double(components[1]),
              let westLon = Double(components[2]),
              let eastLon = Double(components[3]) else {
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

#Preview {
    ContentView()
}
