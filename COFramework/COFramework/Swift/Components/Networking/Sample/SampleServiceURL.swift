//
//  SampleServiceURL.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation

/**
 ServiceURL stores list of ApiTypes which defined
 path, method and paramaters to specific request.
 
 Example:
    case .test: return("/test1", .get, nil")
    case .test: return("/test2", .post, ["param": prarm]")
    case .test: return("/test3", .put, ["param": prarm]")
 */

public enum SampleServiceURL {
    
    case sampleAPI(firstName: String, lastName: String)
    
    var currentEnv: SampleEnvironments {
        return .dev
    }

    var apis: ApiType {
        switch self {
            case .sampleAPI(let firstName, let lastName):
                
                let params:[String: Any] = [
                    "firstName": firstName,
                    "lastName": lastName
                ]
                
                return ("/sample", "get", params)
        }
    }
    
    public var urlRequest: URLRequest? {
        return AppURLRequest(api: self.apis, baseURL: self.currentEnv.baseURL).urlRequest
    }
}

