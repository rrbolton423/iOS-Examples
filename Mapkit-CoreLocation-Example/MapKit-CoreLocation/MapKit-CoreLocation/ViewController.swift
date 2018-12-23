//
//  ViewController.swift
//  MapKit-CoreLocation
//
//  Created by Romell Bolton on 12/23/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit
import MapKit // Import MapKit
import CoreLocation // Import CoreLocation

class ViewController: UIViewController {

    // Define reference to MapView in Storyboard
    // MKMapView: An embeddable map interface, similar to the one provided by the Maps application.
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the map
        setMap()
    }
    
    // This method displays the map on screen
    func setMap() {
        
        // CLLocationCoordinate2DMake: The latitude and longitude associated with a location, specified using the WGS 84 reference frame.
        // This location coordinate is Chicago, IL
        let location = CLLocationCoordinate2DMake(41.8781, -87.6298)
        
        // Define the span of the map to display
        // MKCoordinateSpan: The width and height of a map region.
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        
        // Create region for map, passing the location and span
        // MKCoordinateRegion: A rectangular geographic region centered around a specific latitude and longitude.
        let region = MKCoordinateRegion(center: location, span: span)
        
        // Set the region on the map
        map.setRegion(region, animated: true)
        
        // Use satellite imagery of the area.
        map.mapType = .satellite
        
        // Create Map Annotation
        // MKPointAnnotation: A concrete annotation object tied to the specified point on the map.
        let annotation = MKPointAnnotation()
        
        // Assign the annotation to the proper location coordinate
        annotation.coordinate = location
        
        // Give title to annotation
        annotation.title = "Chicago, IL"
        
        // Add annotation to Map
        map.addAnnotation(annotation)
    }


}

