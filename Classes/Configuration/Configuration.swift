//
//  Configuration.swift
//  SRNetworking
//
//  Created by Sriram on 09/10/19.
//  Copyright © 2019 Sriram Rajendran. All rights reserved.
//

import Foundation

public struct NetworkConfiguration {
    let baseUrl: String
    
    public init(base: String) {
        self.baseUrl = base
    }
}
