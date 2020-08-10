//
//  ViewController.swift
//  LearnMapKitCoreLocation
//
//  Created by Rizal Hilman on 10/08/20.
//  Copyright © 2020 Rizal Hilman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let coordinates = [
        CLLocation(latitude: 1.1061034, longitude: 104.0378246),
        CLLocation(latitude: 1.1042292748651636, longitude: 104.028639793396)
    ]
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        // Do any additional setup after loading the view.
//        if CLLocationManager.locationServicesEnabled() {
//            // Jika di enabled
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            // trigger request permission
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//
//        }

        // Tambahkan semua coordinate menjadi annotation di map
        for placeLocation in coordinates {
            let annotation = MKPointAnnotation()
            annotation.title = "Batam Airport"
            annotation.coordinate = placeLocation.coordinate
            
            mapView.addAnnotation(annotation)
        }
        
        // Draw route with native iOS Maps App
//        let source = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[0].coordinate))
//        source.name = "Source"
//        let destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[1].coordinate))
//        destination.name = "Destination"
//
//        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])

        
        // Draw route inside the app
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[0].coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[1].coordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
            
        }
        
        // Untuk menampilkan semua annotations di mapkit
        mapView.layoutMargins = UIEdgeInsets(top: 10, left: 80, bottom: 10, right: 80)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.orange
        return renderer
    }
    
    func centerToLocation(location: CLLocation, regionRadius: CLLocationDistance = 100) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let annotation = MKPointAnnotation()
        annotation.title = "User Location"
        annotation.coordinate = location.coordinate
        
        mapView.addAnnotation(annotation)
        centerToLocation(location: location)
    }
    
}

