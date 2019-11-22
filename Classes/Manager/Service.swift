//
//  RequestManager.swift
//  SRNetworking
//
//  Created by Sriram on 09/10/19.
//  Copyright © 2019 Sriram Rajendran. All rights reserved.
//

import Foundation

public class APIService {
    
    var agent: NetworkAgent
    
    public init() {
        agent = NetworkAgent()
    }
    
    
    public func load<T: Codable>(endpoint: Endpoint?, completionHandler: @escaping (Result <T>) -> Void) {
        agent.dataRequest(with: endpoint?.asURLrequest(), objectType: T.self) { (result: Result <T>) in
                completionHandler(result)
        }
    }
    
    public func downloadImage(url: URL,  completionHandler: @escaping (Result <UIImage>) -> Void) {
        agent.imageDownloadRequest(with: url) { (result) in
            completionHandler(result)
        }
    }
}

