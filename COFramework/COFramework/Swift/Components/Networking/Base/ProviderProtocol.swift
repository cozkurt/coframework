//
//  ProviderProtocol.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation

/**
 ProviderProtocol provides a signatures for requests method as a wrapper. You can perform these method to provide any type of networking.
  Currently AlamofireProvider and TestProvider confirms this protocol. Let's say if you need to use Apple's URLSesson networking you can create another
   provider that confirms this protocol.
*/

public protocol ProviderProtocol {

    // MARK: - ServiceProvider Protocol Properties
    
    var description: String { get }

    // MARK: - Service Protocol Methods
    func request(_ urlRequest: URLRequest?, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void)
}
