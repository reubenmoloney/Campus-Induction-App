//
//  waypointManager.swift
//  CampusInduction
//
//  Created by cathair mab on 05/03/2025.
//
import Foundation
import CoreLocation

struct WaypointManager {

    static let shared = WaypointManager()
    
    static let waypoints: [BuildingAnnotation] = [
        BuildingAnnotation(coordinate: CLLocationCoordinate2D(latitude: 55.90936, longitude: -3.32041), title: "Reception"),
        BuildingAnnotation(coordinate: CLLocationCoordinate2D(latitude: 55.90855, longitude: -3.32195), title: "Library"),
        BuildingAnnotation(coordinate: CLLocationCoordinate2D(latitude: 55.911027, longitude: -3.31832), title: "Student Union"),
        BuildingAnnotation(coordinate: CLLocationCoordinate2D(latitude: 55.90953, longitude: -3.31739), title: "Oriam"),
        BuildingAnnotation(coordinate: CLLocationCoordinate2D(latitude: 55.91167, longitude: -3.32020), title: "The Grid"),
        BuildingAnnotation(coordinate: CLLocationCoordinate2D(latitude: 55.90971, longitude: -3.31805), title: "Music Cottage")
    ]

    static func checkForNearbyWaypoint(userLocation: CLLocationCoordinate2D) -> BuildingAnnotation? {
        for waypoint in waypoints {
            let distance = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                .distance(from: CLLocation(latitude: waypoint.coordinate.latitude, longitude: waypoint.coordinate.longitude))
            
            if distance < 10 { // Within 10 meters
                return waypoint
            }
        }
        return nil
    }
}
