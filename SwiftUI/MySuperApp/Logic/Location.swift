//
//  Location.swift
//  MySuperApp
//
//  Created by Hristo Hristov on 11.06.20.
//  Copyright © 2020 Hristo Hristov. All rights reserved.
//

import Foundation
import CoreLocation


class Location : NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            print("Start updating locatoin")
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        let latitude = lastLocation.coordinate.latitude
        let longitude = lastLocation.coordinate.longitude
        print(lastLocation)
        print(String(format: "long: %f, lat: %f", arguments:[longitude, latitude]))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            print("Location updates are not authorized")
            manager.stopUpdatingLocation()
            return
        }
        print("error")
    }
    
}
