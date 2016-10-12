//
//  AddNoteViewController.swift
//  Microsoft_Hackathon_1
//
//  Created by Aiman Abdullah Anees on 12/10/16.
//  Copyright © 2016 Aiman Abdullah Anees. All rights reserved.
//
import UIKit
import MobileCoreServices
import CoreLocation
import Firebase
import FirebaseDatabase


class AddNoteViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var titleView: UITextView!
    
    @IBOutlet weak var noteView: UITextView!
    
    var copyCount:Int = 0
    
    
    
    var imagePicker = UIImagePickerController()
    
    let locationManager = CLLocationManager()
    var note:String!
    var title1:String!
    var copyNote:String!
    var copyTitle:String!
    var latitude:Double!
    var longitude:Double!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        titleView.becomeFirstResponder()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.text = ""
        noteView.text = ""
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    
    
    @IBAction func keyBoardButton(_ sender: AnyObject) {
        titleView.resignFirstResponder()
    }
    
    
  
    
    @IBAction func photoLibraryButton(_ sender: AnyObject) {
        title1 = titleView.text
        note = noteView.text
        copyNote = note
        copyTitle = title1
        print(self.latitude)
        print(self.longitude)
        print(title1)
        print(note)
        
        //^^^^^^^POSTING OPERATION^^^^^^^^^
        let post : [String : AnyObject] = ["title" : title1 as AnyObject,"note": note as AnyObject, "latitude" : self.latitude as AnyObject, "longitude" : self.longitude as AnyObject]
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Posts").childByAutoId().setValue(post)
        
        
        var alert = UIAlertController(title: "Note Posted!", message: "You can view your post in 'View Map' or 'View in Air'", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        titleView.text = ""
        noteView.text = ""
        

        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        latitude = location?.coordinate.latitude
        longitude = location?.coordinate.longitude
        locationManager.stopUpdatingLocation()
        
    }
    
}

