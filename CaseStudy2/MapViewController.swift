//
//  MapViewController.swift
//  CaseStudy2
//
//  Created by Capgemini-DA233 on 04/07/1944 Saka.
//

import UIKit
import CoreLocation  // Core Location provides services that determine a device’s geographic location, altitude, and orientation, or its position
import MapKit //MapKit is a powerful API available on iOS devices that makes it easy to display maps, mark locations, enhance with custom data and even draw routes or other shapes on top

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var locationManager : CLLocationManager!   //Create an Object of CLLocationManager
    var currentLocationStr = "Current location"
    
    @IBOutlet weak var userMapView: MKMapView!  // mk map view
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation();
        }
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    //MARK:- CLLocationManagerDelegate Methods

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let mUserLocation:CLLocation = locations[0] as CLLocation

            let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
            let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            userMapView.setRegion(mRegion, animated: true)
            // Get user's Current Location and Drop a pin
            let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
                mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
                mkAnnotation.title = self.setUsersClosestLocation(mLattitude: mUserLocation.coordinate.latitude, mLongitude: mUserLocation.coordinate.longitude)
                userMapView.addAnnotation(mkAnnotation)
        }
    //MARK:- Intance Methods

    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)

        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) in
            if (error) == nil{
                if placemarks!.count > 0 {
                    let placemark1 = placemarks?[0]
                    let address = "\(placemark1?.country ?? ""),\(placemark1?.postalCode ?? ""),\(placemark1?.locality ?? "")"
                    
                    DispatchQueue.main.async{
                    self.currentLocationStr = address
                    print("\(address)")
                    }
                }
            }
        }
            return currentLocationStr
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error - locationManager: \(error.localizedDescription)")
        }
    //MARK:- Intance Methods

    
     
}
