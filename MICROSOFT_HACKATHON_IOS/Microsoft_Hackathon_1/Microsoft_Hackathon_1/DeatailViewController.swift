//
//  DeatailViewController.swift
//  Microsoft_Hackathon_1
//
//  Created by Aiman Abdullah Anees on 12/10/16.
//  Copyright © 2016 Aiman Abdullah Anees. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseDatabase

struct Firebasepull {
    let title1 : String!
    let note : String!
    let latitude : Double!
    let longitude : Double!
}



class DeatailViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    var posts = [Firebasepull]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.mapView.showsBuildings = true
        self.mapView.showsCompass = true
        self.mapView.showsScale = true
        
        //^^^^^Pushing Points^^^^^
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("Posts").queryOrderedByKey().observe(.childAdded, with: {(snapshot) in
            
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let title1 = dictionary["title"] as? String
                let note = dictionary["note"] as? String
                let latitude = dictionary["latitude"] as? Double
                let longitude = dictionary["longitude"] as? Double
                
                self.posts.insert(Firebasepull(title1:title1,note:note,latitude:latitude,longitude:longitude), at: 0)
                
            }
            }, withCancel: nil)
        
        


        // Do any additional setup after loading the view.
    }
    
    func centerMapOnLocation(location:CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        var i:Int = 0
        while(i < self.posts.count){
            let annotation = MKPointAnnotation()
            let anno_center = CLLocationCoordinate2DMake(self.posts[i].latitude, self.posts[i].longitude)
            annotation.coordinate = anno_center
            annotation.title = self.posts[i].title1
            annotation.subtitle = self.posts[i].note
            mapView.addAnnotation(annotation)
            i=i+1
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    


   



}
