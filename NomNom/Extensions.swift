//
//  Extintions.swift
//  NomNom
//
//  Created by Joseph Hassell on 3/26/24.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}


//extension MKMapItem: Equatable {}
//
//public func ==(lhs: MKMapItem, rhs: MKMapItem) -> Bool {
//    return lhs.hash == rhs.hash && lhs.hash == rhs.hash
//}
