//
//  MapView.swift
//  CampusInduction
//
//  Created by cathair mab on 12/02/2025.
//

import SwiftUI
import MapKit

struct TiltedMapViewWithMarkers: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var userLocation: CLLocationCoordinate2D?
    let buildingAnnotations: [BuildingAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
        mapView.pointOfInterestFilter = .excludingAll
        mapView.camera = setupCamera(mapView: mapView)
        
        for building in buildingAnnotations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = building.coordinate
            annotation.title = building.title
            mapView.addAnnotation(annotation)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update logic if needed
    }
    
    func setupCamera(mapView: MKMapView) -> MKMapCamera {
        let camera = MKMapCamera()
        camera.centerCoordinate = region.center
        camera.pitch = 45.0
        camera.altitude = 300
        return camera
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: TiltedMapViewWithMarkers
        let maxAltitude: CLLocationDistance = 750
        var zoomTimer: Timer?
        
        init(_ parent: TiltedMapViewWithMarkers) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let camera = mapView.camera
            if camera.altitude > maxAltitude {
                startSmoothZoom(mapView: mapView, targetAltitude: maxAltitude)
            }
        }
        
        private func startSmoothZoom(mapView: MKMapView, targetAltitude: CLLocationDistance) {
            zoomTimer?.invalidate()
            zoomTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                let camera = mapView.camera
                if camera.altitude > targetAltitude {
                    camera.altitude -= 50
                    mapView.setCamera(camera, animated: false)
                } else {
                    timer.invalidate()
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation { return nil }
            
            let identifier = "BuildingMarker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.glyphImage = UIImage(systemName: "building.2.crop.circle")
                annotationView?.markerTintColor = .systemGreen
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
    }
}
