//
//  GPSLocation.swift
//  GetDeviceStatsApp
//
//  Created by Андрей Бабий on 24.05.18.
//  Copyright © 2018 Андрей Бабий. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol GPSLocationProtocol {
    func callbackLocation(latitude: Double, longitude: Double)
    func callbackErrorLocation(location: String)
}

class GPSLocation: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var delegate: GPSLocationProtocol?
    
    func getGPSLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        locationManager.stopUpdatingLocation()
        delegate?.callbackLocation(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        if let cLError = error as? CLError {
            switch cLError {
            case CLError.locationUnknown:
                //print("Location unnowned")
                delegate?.callbackErrorLocation(location: "Null")
            case CLError.denied:
                //print("NoPerm")
                delegate?.callbackErrorLocation(location: "NoPerm")
            default:
                //print("Another error")
                delegate?.callbackErrorLocation(location: "Error")
            }
        } else {
            ///print("other error:" , error.localizedDescription)
        }
        
    }
    
}
