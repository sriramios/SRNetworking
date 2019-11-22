//
//  ViewController.swift
//  SRNetworking
//
//  Created by SR on 25/09/19.
//  Copyright © 2019 Sriram Rajendran. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    var interactor: WeatherViewInteractorInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        interactor = WeatherViewInteractor(with: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.getLocation()        
    }

}

extension WeatherViewController: WeatherViewInteractorOutput {
    func displayLocationInfo(location: ForeCastInfo) {
        print(location)
    }
}

