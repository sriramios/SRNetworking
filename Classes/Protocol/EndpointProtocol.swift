//
//  EndpointProtocol.swift
//  SRNetworking
//
//  Created by Sriram on 09/10/19.
//  Copyright © 2019 Sriram Rajendran. All rights reserved.
//
import Foundation

public typealias HeaderParams = [String: String]
public typealias QueryParams = [String: String]
public typealias Parameters = [String: AnyObject]

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}



/* Endpoint protocol defines a set a rules, on conforming to which, a type can
 be classfied as a API request */
public protocol Endpoint {
    var Config: NetworkConfiguration { get }
    var urlComponents: URLComponents { get }// base url of the request
    var path: String? { get } // path component of the url
    var method: HTTPMethod? { get } // HTTP Method (e.g. GET, POST etc)
    var headers: HeaderParams? { get } // Header parameters
    var parameters: Parameters? { get } // Request Body/ Query Params
    var queryParams: QueryParams? { get } // Request Body/ Query Params
    func asURLrequest() -> URLRequest?
}

// MARK: -

/// A dictionary of parameters to apply to a `URLRequest`.

/// A type used to define how a set of parameters are applied to a `URLRequest`.
public protocol ParameterEncoding {
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
    ///
    /// - returns: The encoded request.
    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest
}


extension HTTPMethod: ParameterEncoding {
    public func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        guard let parameters = parameters else { return urlRequest }

        var urlReq: URLRequest = urlRequest
        switch self {
        case .get:
            guard let url = urlRequest.url else {
                throw APIError.parameterEncodingFailed
            }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                urlComponents.setQueryItems(with: parameters as! [String : String])
            }
            return urlReq

        default:
            if urlReq.value(forHTTPHeaderField: "Content-Type") == nil {
                urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlReq.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
           return urlReq
        }
    }
}

extension Endpoint {
    
    public var baseURL: String { return Config.baseUrl }
    public var path: String? { return nil }
    public var method: HTTPMethod? { return .get }
    public var headers: HeaderParams? { return [:] }
    public var parameters: Parameters? { return nil }
    public var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Config.baseUrl
        return urlComponents
    }

    public func asURLrequest() -> URLRequest? {
        guard let urlPath = self.path else {
            return nil
        }
        
        var urlComponents = self.urlComponents
        urlComponents.path = urlPath
        
        if let reqParams = self.queryParams {
            urlComponents.setQueryItems(with: reqParams)
        }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = method?.rawValue
        
        var urlEncoded: URLRequest?
        
        do {
            urlEncoded = try method?.encode(urlRequest, with: parameters)
        } catch  {
            return urlRequest
        }
        return urlEncoded
        
    }
}




extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        if let existingQueryParam = self.queryItems {
            self.queryItems =  existingQueryParam + parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        } else {
            self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
    }
    
}
