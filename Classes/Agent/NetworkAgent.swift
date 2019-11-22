//
//  NetworkAgent.swift
//  SRNetworking
//
//  Created by Sriram on 09/10/19.
//  Copyright © 2019 Sriram Rajendran. All rights reserved.
//

import Foundation

public enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
    case parameterEncodingFailed
}

//Enum case to show success or failure for Response Result
public enum Result<T> {
    case success(T)
    case failure(APIError)
}

public class NetworkAgent: NSObject {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: configuration)
    }
    
    //dataRequest which sends request to given URL and convert to Decodable Object
    func dataRequest<T: Codable>(with request: URLRequest?, objectType: T.Type, completion: @escaping (Result<T>) -> Void) {
        
        //create the url with NSURL
        
        //create the session object
        
        guard let request = request else {
            completion(Result.failure(APIError.invalidURL))
            return  }
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(Result.failure(APIError.networkError(error!)))
                    return
                }
                
                guard let data = data else {
                    completion(Result.failure(APIError.dataNotFound))
                    return
                }
                
                do {
                    //create decodable object from Json Data
                    let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                    completion(Result.success(decodedObject))
                } catch let error {
                    completion(Result.failure(APIError.jsonParsingError(error as! DecodingError)))
                }
            }
            
        })
        
        task.resume()
    }
    
    //image Request which sends request to given URL and convert to image
    func imageDownloadRequest(with request: URL?, completion: @escaping (Result<UIImage>) -> Void) {
        
        //create the session object
        
        guard let request = request else {
            completion(Result.failure(APIError.invalidURL))
            return  }
        //create dataTask using the session object to download image
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(Result.failure(APIError.networkError(error!)))
                    return
                }
                
                guard let data = data,  let image = UIImage(data: data)  else {
                    completion(Result.failure(APIError.dataNotFound))
                    return
                }
                
                completion(Result.success(image))
            }
            
        })
        
        task.resume()
    }
}
