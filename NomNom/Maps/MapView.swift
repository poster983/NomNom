//
//  MapView.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/26/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var mapController: MapController;
    var body: some View {
        MapReader{ reader in
            
            Map{
                if(mapController.selectedCoordinates != nil) {
                    Marker("Selected Point", systemImage: "mappin.and.ellipse", coordinate: mapController.selectedCoordinates!)
                }
                if(!mapController.geocodedPoints.isEmpty) {
                    ForEach(mapController.geocodedPoints, id: \.self) { point in
                        Marker(item: point)
                    }
                    
                    
                }
                if(mapController.geocodedBoundingBox.count > 0) {
                    MapPolygon(points: mapController.geocodedBoundingBox)
                        .foregroundStyle(.red.opacity(0.60))
                }
                
            }
            .coordinateSpace(.named("map"))
            .onTapGesture(perform: { screenCoord in
                mapController.selectedCoordinates = reader.convert(screenCoord, from: .local)
                
                
            })
        }
    }
}

#Preview {
    MapView(mapController: MapController())
}
