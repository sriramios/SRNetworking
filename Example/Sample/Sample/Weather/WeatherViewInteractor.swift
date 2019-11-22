//
//  WeatherViewInteractor.swift
//  SRNetworking
//
//  Created by srajend1 on 10/10/19.
//  Copyright © 2019 Sriram Rajendran. All rights reserved.
//

import Foundation
import CoreLocation
import SRNetworking

protocol WeatherViewInteractorInput: NSObjectProtocol {
    func getLocation()
}

protocol WeatherViewInteractorOutput: NSObjectProtocol {
    func displayLocationInfo(location: ForeCastInfo)
}

class WeatherViewInteractor: NSObject {

    weak var output: WeatherViewInteractorOutput?
    var locationInteractor: LocationManagerInput?
    
    init(with output: WeatherViewInteractorOutput?) {
        self.output = output
    }
    
    func makeAPICall(_ location: CLLocation) {
        
        let webService = APIService.init()
        weak var weakSelf = self
        webService.load(endpoint: SampleRequest.getUserId(lat: "\(location.coordinate.latitude)",lon: "\(location.coordinate.longitude)") as Endpoint) { (result: Result<ForeCastInfo>) in
            
            switch result {
            case .success(let todo) :
                print(todo)
                weakSelf?.output?.displayLocationInfo(location: todo)
            case .failure(let error):
                print("Error \(error)")
            }
        }
    }
    
    func downloadImage() {
        let webService = APIService.init()
        webService.downloadImage(url: URL(string: "https://res.cloudinary.com/demo/image/upload/w_400,h_400,c_crop,g_face,r_max/w_200/lady.jpg")!) { (result: Result<UIImage>) in
            switch result {
            case .success :
                print("Image downloaded")
            case .failure(let error):
                print("Error \(error)")
            }
        }

    }
    
}

extension WeatherViewInteractor: WeatherViewInteractorInput{
    func getLocation() {
        locationInteractor = LocationManager(with: self)
        locationInteractor?.fetchLocation()
    }
}

extension WeatherViewInteractor: LocationManagerOutput{
    func didFailLocation(error: Error) {
        
    }
    
    func didReceiveLocation(location: CLLocation) {
        makeAPICall(location)
    }
}
