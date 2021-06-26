//
//  AppURLRequest.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation
import Network

/**
 AppURLRequest is used for AlamofireProvider to provide
  urlRequest object to be constructed.
 */

typealias ApiType = (path: String, method: String, parameters: [String: Any]?)

class AppURLRequest {

    /// api type to urlRequests
    var api: ApiType
    var baseURL: String?
    
    init(api: ApiType, baseURL: String?) {
        self.api = api
        self.baseURL = baseURL
    }
    
    var urlRequest: URLRequest? {
        
        guard let baseURL = self.baseURL, let url = URL(string: baseURL + api.path),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return nil
        }
        
        // if HTTPMethod is GET then construct queryItems array
        
        if let params = api.parameters, api.method == "get" {
            var queryItems: [URLQueryItem] = []
            
            for (key, value) in params {
                queryItems.append(
                    URLQueryItem(
                        name: key,
                        value: (value as AnyObject).addingPercentEncoding(
                            withAllowedCharacters: CharacterSet.urlQueryAllowed)))
            }
            
            // assign if query items exists
            if !queryItems.isEmpty {
                components.queryItems = queryItems
            }
        }
        
        // prepare URLRequest
        
        var urlRequest = URLRequest(url: components.url ?? url)
        urlRequest.httpMethod = api.method
        urlRequest.timeoutInterval = TimeInterval(20)
        
        return urlRequest
    }
}
