//
//  URLSessionProvider.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation

/**
 URLSessionProvider class confirms ProviderProtocol
 as a new networking provider for local json mocking purposes.
 */

public class URLSessionProvider: ProviderProtocol {

    let session = URLSession.shared
    
    // MARK: - Init Methods
    
    public init() {}
    
    // MARK: - ServiceProvider Protocol Properties
    
    public var description: String {
        return "URLSession Provider"
    }

    // MARK: - Public Methods

    public func request(_ urlRequest: URLRequest?, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        
        guard let urlRequest = urlRequest else {
            let error = NSError(domain: "com.coframework", code: 0, userInfo: ["error": "Invalid URL"])
            failure(error)
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                failure(error as Error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                let error = NSError(domain: "com.coframework", code: 0, userInfo: ["error": "Server Error"])
                failure(error as Error)
                return
            }

            guard let mime = response.mimeType, mime == "application/json" else {
                let error = NSError(domain: "com.coframework", code: 0, userInfo: ["error": "Wrong MIME Type"])
                failure(error as Error)
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .ascii) {
                success(responseString)
            } else {
                let error = NSError(domain: "com.coframework", code: 0, userInfo: ["error": "No data found"])
                failure(error as Error)
            }
        }
        
        task.resume()
    }
}
