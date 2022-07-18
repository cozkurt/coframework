//
//  AlamofireProvider.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 20/04/21.
//  Copyright © 2021 Cenker Ozkurt, All rights reserved.
//

#if !targetEnvironment(macCatalyst)

import UIKit
import Alamofire
import ObjectMapper
import Foundation

/**
 AlamofireProvider class confirms ProviderProtocol as a new networking provider.
 */

open class AlamofireProvider: ProviderProtocol {
    
    /// Alamofire session manager
    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        
        return Session(configuration: configuration, interceptor: CORequestInterceptor())
    }()
    
    // MARK: - Init Methods
    
    public init() {}
    
    // MARK: - ServiceProvider Protocol Properties
    
    open var description: String {
        return "Alamofire Provider"
    }
    
    // MARK: - Public Methods that conforms ProviderProtocol
    
    open func request(_ urlRequest: URLRequest?, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
    
        guard let urlRequest = urlRequest else {
            return
        }
        
        Logger.sharedInstance.LogInfo("URlRequest : \(String(describing: urlRequest.url?.absoluteString)) \n HEADER: \(String(describing: urlRequest.allHTTPHeaderFields))")
        
        sessionManager.request(urlRequest).validate().responseString { responseString in
            
            Logger.sharedInstance.LogInfo("******** Response: \(String(describing: responseString))")
            
            if let data = responseString.value {
                success(data)
            } else if let error = responseString.error {
                failure(error as NSError)
            }
        }
    }
}

class CORequestInterceptor: RequestInterceptor {
    let retryLimit = 3
    let retryDelay: TimeInterval = 10

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
      let response = request.task?.response as? HTTPURLResponse
      if let statusCode = response?.statusCode, (500...599).contains(statusCode), request.retryCount < retryLimit {
          
          // retry
          Logger.sharedInstance.LogInfo("retrying request \(request.retryCount)...")
          completion(.retryWithDelay(retryDelay))
          
      } else {
          // server not found, no need to retry
          return completion(.doNotRetry)
      }
    }
}

#endif
