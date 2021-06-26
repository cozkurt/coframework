//
//  SampleAPIFactory.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import ObjectMapper
import Foundation

/**
 APIFactory stores all API calls that is defined in
 ServiceURL enum for list of APIType cases.
 
 Returned responses also store in the class for later use
 without making another call.
 
 If you need another API call, you need to add new signature to APIType
 
 Example:
    APIFactory.sharedInstace.APIFactory(AlamofreProtocol(), ...)    This will use AlamofireProvider to make API call to server
    APIFactory.sharedInstace.APIFactory(TestProtocol(), ...)    This will use TestProvider to load json file locally for mocking.
 */

public class SampleAPIFactory {
    
    /// api responses
    public var sampleResponse: SampleModel?
    
    //
    // MARK: - sharedInstance for singleton access
    //
    public static let sharedInstance: SampleAPIFactory = SampleAPIFactory()
    
    /**
     qrcode
     
     - parameters:
     - success: A closure to be executed on success.
     - failure: A closure to be executed on failure.
     */
    
    public func sampleAPI(firstname: String,
                          lastName: String,
                          _ provider: ProviderProtocol,
                          success: @escaping () -> Void,
                          failure: @escaping (Error?) -> Void) {

        let urlRequest = SampleServiceURL.sampleAPI(firstName: firstname, lastName: lastName).urlRequest
        
        Logger.sharedInstance.LogDebug("URL Requested : \(urlRequest?.url?.absoluteString ?? "")")
        
        provider.request(urlRequest, success: { (jsonString) in
            let jsonData = jsonString.data(using: .utf8)!
            do {
                let response = try JSONDecoder().decode(SampleModel.self, from: jsonData)
                self.sampleResponse = response
                
                success()
            } catch {
                failure(nil)
            }
        }, failure: { (error) in
            failure(error)
        })
        
        //
        // ObjectMapper parsing
        //
        
        /*
        provider.request(urlRequest, success: { (JSONString) in

            let mappable = Mapper<SampleModel>()

            if let responseModel = mappable.map(JSONString: JSONString) {
                self.sampleResponse = responseModel
                success()
            } else {
                failure(nil)
            }

            }, failure: { error in
                failure(error)
        })
         */
    }
}
