//
//  SampleRequest.swift
//  SRNetworking
//
//  Created by Sriram on 09/10/19.
//  Copyright © 2019 Sriram Rajendran. All rights reserved.
//

import Foundation
import SRNetworking

//https://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=b6907d289e10d714a6e88b30761fae22


enum SampleRequest: Endpoint {
    
    case getUserId(lat: String, lon: String)
    
    var Config: NetworkConfiguration {
        return NetworkConfiguration.init(base: "samples.openweathermap.org", token: "b6907d289e10d714a6e88b30761fae22")
    }
    
    var gzipEnabled: Bool { return true}
    
    var queryParams: QueryParams? {
        switch self {
        case .getUserId(let lat, let lon):
            return ["lat":lat, "lon":lon]
        }
    }
    
    var path: String? { return "/data/2.5/weather"}
    
}
