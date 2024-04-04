//
//  InspectorView.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/26/24.
//

import SwiftUI
import CoreLocation
import MapKit
import SwiftOverpassAPI
struct InspectorView: View {
//    @Binding var searchMode: SearchMode;
//    @Binding var coordinates: CLLocationCoordinate2D;
    
    @ObservedObject var mapController: MapController;
    
    @State var err: String? = nil;
    
    @State var nominatiumData: NominatimPlace?;
    @State var appleData: [MKMapItem] = [];
    @State var overpassData: [OverpassData] = [];
    var body: some View {
        Form {
            Picker("", selection: $mapController.searchMode) {
                Text("Nominatim").tag(SearchMode.nominatim)
                Text("Overpass").tag(SearchMode.overpass)
                Text("Apple").tag(SearchMode.apple)
            }
            .pickerStyle(.segmented)
            .onChange(of: mapController.searchMode, initial: false) {
                getData()
                
            }
//            Spacer()
            
            if(err != nil) {
                Text(err!)
            }
            
            switch mapController.searchMode {
            case .nominatim:
                if(nominatiumData != nil) {
                    NominatimDataListView(place: $nominatiumData)
//                        .frame(height:.infinity)
                }
            case .apple:
                if(!appleData.isEmpty) {
                    AppleDataListView(places: $appleData)
                }
            case .overpass:
                if(!overpassData.isEmpty) {
                    OverpassDataView(places: overpassData)
                }
            
                
//            default:
//                Text("Not yet implemented")
////                Spacer()
            }
        }
        .onChange(of: mapController.selectedCoordinates, initial: false) {
            nominatiumData = nil;
            appleData = [];
            overpassData = [];
            
            getData()
        }
        
        
    }
    
    func updateMap() {
        if(mapController.searchMode == .nominatim && nominatiumData != nil) {
            mapController.geocodedPoints = [MKMapItem(placemark: MKPlacemark( coordinate: CLLocationCoordinate2D(latitude: Double(nominatiumData!.lat!)!, longitude: Double(nominatiumData!.lon!)!)))]
            mapController.geocodedPoints[0].name = nominatiumData!.displayName
            mapController.geocodedBoundingBox = nominatiumData!.mapkitBoundBox
            
        } else if (mapController.searchMode == .apple && !appleData.isEmpty) {
            mapController.geocodedPoints = appleData
            mapController.geocodedBoundingBox = []
        } else if (mapController.searchMode == .overpass && !overpassData.isEmpty) {
            mapController.geocodedPoints = overpassData.map { data in
                data.mapItem
            };
            
            
//            let visualizations = OPVisualizationGenerator
//                .mapKitVisualizations(forElements: overpassData)
////            visualizations
//            for visualization in visualizations {
//                let name = overpassData[visualization.key]?.tags["name"]
//                switch visualization.value {
//                case .annotation(let annotation):
//                    let e = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
//                    e.name = name
//                    mapController.geocodedPoints.append(e)
////                    newAnnotations.append(annotation)
//                    //                        case .polyline(let polyline):
//                    //                            polylines.append(polyline)
//                    //                        case .polylines(let newPolylines):
//                    //                            polylines.append(contentsOf: newPolylines)
//                case .polygon(let polygon):
//                    
//                    let e = MKMapItem(placemark: MKPlacemark(coordinate: polygon.coordinate ))
//                    e.name = name
//                    
//                    mapController.geocodedPoints.append(e)
////                    polygons.append(polygon)
////                case .polygons(let newPolygons):
////                    newPolygons[0].in
////                    polygons.append(contentsOf: newPolygons)
//                default:
//                    print("Unsupported type")
//                }
//            }
//            mapController.geocodedPoints = overpassData.map({ point in
//                point.geometry.
//            })
            mapController.geocodedBoundingBox = []
        } else {
            //remove all points
            mapController.geocodedPoints = [];
            mapController.geocodedBoundingBox = [];
            
        }
            
    }
    
    func getData() {
        guard mapController.selectedCoordinates != nil else {
            return
        }
        Task {
            err = nil;
            do {
                //MARK: nominatim
                if(mapController.searchMode == .nominatim && nominatiumData == nil) {
                    
                        nominatiumData = try await NominatimPlace.geocode(coordinate: mapController.selectedCoordinates!)
                        if(nominatiumData == nil) {
                            err = "No Data"
//                            return
                        }
                    
                } else if(mapController.searchMode == .apple && appleData.isEmpty) {
                    
                    appleData = try await AppleData.geocodeMapkit(tappedPlace: mapController.selectedCoordinates!)
                    if(appleData.isEmpty) {
                        err = "No Data"
//                        return
                    }
                } else if (mapController.searchMode == .overpass && overpassData.isEmpty) {
                    overpassData = try await OverpassData.geocode(center: mapController.selectedCoordinates!)
                    if(overpassData.isEmpty) {
                        err = "No Data"
//                        return
                    }
                    
                    
                } else {
                    print("Using Cashed")
                }
                
                
                updateMap();
            } catch {
                err = error.localizedDescription
            }
            
            
            
            
        }
    }
    
}

//#Preview {
//    InspectorView()
//}
