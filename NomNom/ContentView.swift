//
//  ContentView.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/25/24.
//

import SwiftUI
import MapKit

///https://wiki.openstreetmap.org/wiki/Map_features#Food,_beverages

enum SearchMode {
    case apple
    case nominatim
    case overpass
}

struct ContentView: View {
    @ObservedObject var mapController = MapController()

    @State var inspectorPresented: Bool = false
    var body: some View {
        MapView(mapController: mapController)
            .inspector(isPresented: $inspectorPresented) {
                InspectorView(mapController: mapController)
            }
            .onChange(of: mapController.geocodedPoints) {
//                print("mapController.geocodedPoint")
                inspectorPresented = !mapController.geocodedPoints.isEmpty
            }
        
        
//        GeometryReader{ geomReader in
//            var isHorizontal = geomReader.size.height < geomReader.size.width
//            //            let layout = isHorizontal ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
//            
//            let content = MapReader{ reader in
//                
//                Map{
//                    if(selectedItem != nil) {
//                        Marker(item:selectedItem!)
//                            
//                    }
//                    if(boundingBox.count > 0) {
//                        MapPolygon(points: boundingBox)
//                            .foregroundStyle(.red.opacity(0.60))
//                    }
//                    
//                }
//                .coordinateSpace(.named("map"))
//                .onTapGesture(perform: { screenCoord in
//                    coordinates = reader.convert(screenCoord, from: .local)
////                    pin.
//                    print(coordinates)
//                    print("h: \(geomReader.size.height) | w: \(geomReader.size.width)")
//                    Task {
//                        do {
//                            let place = try await geocodeOpenStreetMap(coordinate: coordinates!)
//                            if(place.lat == nil || place.lon == nil) {
//                                selectedPlace = nil;
//                                selectedItem = nil;
//                                inspectorPresented = false;
//                                boundingBox.removeAll()
//                                return;
//                                
//                            }
//                            selectedPlace = place
//                            
//                            //placemark MKItem
//                            selectedItem = MKMapItem(placemark: MKPlacemark(
//                                
//                                coordinate: CLLocationCoordinate2D(latitude: Double(place.lat!)!, longitude: Double(place.lon!)!)))
//                            selectedItem!.name = place.displayName
//                            
//                            //polyline
//                            
//                            boundingBox.removeAll()
//                            if(place.boundingbox != nil) {
//                                boundingBox = convertOSMBoundingBox(components: place.boundingbox!)
//                            }
//                            
//                            inspectorPresented = true
//                            
//                            
//                            
//                        } catch {
//                            print(error)
//                            return;
//                        }
//                    }
//                })
//                //                .safeAreaInset(edge: .bottom) {
//                //                    if(!isHorizontal) {
//                //
//                //                        OSMDataView(place: $selectedPlace)
//                //                            .frame( height: !isHorizontal ?
//                //                                    geomReader.size.height/2
//                //                                    :   geomReader.size.width/2
//                //
//                //                            )
//                //
//                //
//                //
//                //                    }
//                //                }
//                
//            } .inspector(isPresented: $inspectorPresented) {
////                NominatimDataView(place: $selectedPlace)
//                if(coordinates != nil) {
//                    InspectorView(searchMode: $searchMode, coordinates: $coordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
//                }
//            }
//            content
//            //            #if os(macOS)
//            //            if(isHorizontal) {
//            //                HSplitView {
//            //                    content
//            //                    OSMDataView(place: $selectedPlace)
//            //
//            //                }
//            //
//            //            } else {
//            //                VSplitView {
//            //                    content
//            //                    OSMDataView(place: $selectedPlace)
//            ////                        .frame( height: geomReader.size.height/2)
//            //                }
//            //            }
//            //            #else
//            //            if(isHorizontal) {
//            //                HStack {
//            //                    content
//            //                    OSMDataView(place: $selectedPlace)
//            //                        .frame( width: geomReader.size.width/2)
//            //
//            //                }
//            //
//            //            } else {
//            //                VStack {
//            //                    content
//            //                    OSMDataView(place: $selectedPlace)
//            //                        .frame( height: geomReader.size.height/2)
//            ////                        .frame( height: geomReader.size.height/2)
//            //                }
//            //            }
//            //            #endif
//            //            content
//            
//        }
//        
//        .toolbar {
//            ToolbarItemGroup(placement: .primaryAction) {
//                Group {}
//                    .searchable(text: .constant("SS"))
//                Toggle(isOn: $inspectorPresented) {
//                    Image(systemName: "sidebar.right")
//                        
//                }.accessibilityLabel("Toggle Sidebar")
//            }
//        }
    }
    
//    func placesSearch(

    

    
//    func convertOSMBoundingBox(components: [String]) -> [MKMapPoint] {
//        // 1. Split the bounding box string into components
//
//        guard components.count == 4,
//              let southLat = Double(components[0]),
//              let northLat = Double(components[1]),
//              let westLon = Double(components[2]),
//              let eastLon = Double(components[3]) else {
//            print("Invalid bounding box format")
//            return []
//        }
//
//        // 2. Create MKMapPoints for each corner
//        let bottomLeft = MKMapPoint(CLLocationCoordinate2D(latitude: southLat, longitude: westLon))
//        let bottomRight = MKMapPoint(CLLocationCoordinate2D(latitude: southLat, longitude: eastLon))
//        let topRight = MKMapPoint(CLLocationCoordinate2D(latitude: northLat, longitude: eastLon))
//        let topLeft = MKMapPoint(CLLocationCoordinate2D(latitude: northLat, longitude: westLon))
//
//        // 3. Return the array of points
//        return [bottomLeft, bottomRight, topRight, topLeft]
//    }
}

#Preview {
    ContentView()
}
