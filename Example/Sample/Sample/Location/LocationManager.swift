//
//  LocationManager.swift
//  SRNetworking
//
//  Created by srajend1 on 10/10/19.
//  Copyright © 2019 Sriram Rajendran. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case locationUpdateFailed
    case locationPermissionFailed
}

protocol LocationManagerInput: NSObjectProtocol {
    func fetchLocation()
}

protocol LocationManagerOutput: NSObjectProtocol {
    func didReceiveLocation(location: CLLocation)
    func didFailLocation(error: Error)
}

class LocationManager: NSObject {
    var locationManager: CLLocationManager?
    weak var output: LocationManagerOutput?

    init(with output: LocationManagerOutput) {
        super.init()
        self.output = output
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    
}

extension LocationManager: LocationManagerInput {
    func fetchLocation() {
        locationManager?.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else {
            output?.didFailLocation(error: LocationError.locationUpdateFailed)
            return
        }
        output?.didReceiveLocation(location: locations.last!)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted || status == .notDetermined{
            output?.didFailLocation(error: LocationError.locationPermissionFailed)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        output?.didFailLocation(error: LocationError.locationUpdateFailed)
    }
}
