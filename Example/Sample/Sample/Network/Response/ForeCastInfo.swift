//
//  ForeCastInfo.swift
//  SRNetworking
//
//  Created by Sriram on 09/10/19.
//  Copyright © 2019 Sriram Rajendran. All rights reserved.
//

import Foundation

struct ForeCastInfo: Codable {
    let coord: Coord
    let name: String
    let base: String?
    var weather: [weather]
}


struct Coord: Codable {
    let lat: Double
    let lon: Double
    
}

struct weather: Codable {
    var description: String?
    var icon: String
}

