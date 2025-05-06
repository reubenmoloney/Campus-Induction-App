//
//  buildingAnnotations.swift
//  CampusInduction
//
//  Created by cathair mab on 12/02/2025.
//

import Foundation
import CoreLocation

struct BuildingAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}
