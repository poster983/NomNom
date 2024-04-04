//
//  MapController.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/26/24.
//

import SwiftUI
import MapKit
import CoreLocation

class MapController: ObservableObject {
    @Published var searchMode: SearchMode = .nominatim
    @Published var selectedCoordinates: CLLocationCoordinate2D?;
    @Published var geocodedPoints: [MKMapItem] = [];
    @Published var geocodedBoundingBox: [[MKMapPoint]] = []
}
