//
//  SampleModel.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

public struct SampleModel: Codable, Mappable {
    
    var id: String?
    var firstName: String?
    var lastName: String?

    // MARK: Mappable protocol conformance
    
    public init?(map: Map) {
        id <- map["id"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
    }
    
    public func mapping(map: Map) {
        /// Mapping already completed in init()
    }
}
