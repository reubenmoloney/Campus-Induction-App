//
//  LocationTrackingManager.swift
//  CampusInduction
//
//  Created by cathair mab on 12/02/2025.
//

import Foundation
import CoreLocation
import MapKit

class LocationTrackingManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.909306, longitude: -3.319896),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Published var userLocation: CLLocationCoordinate2D? = nil
    @Published var traveledPath: [CLLocationCoordinate2D] = []
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
                self.region.center = location.coordinate
                self.traveledPath.append(location.coordinate)
            }
        }
    }
}
