//
//  UIBehaviourModel.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 01/06/20.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation
import ObjectMapper

struct UIBehaviourModel: Mappable, DictionaryHelper {
    
    /// Model Properties
    
    var kingDensity: Float?
    var nodeDensity: Float?
    var attachDamping: Float?
    var snapDamping: Float?
    
    // MARK: Mappable protocol conformance
    
    init?(map: Map) {
        
        // Model Properties
        kingDensity <- map["kingDensity"]
        nodeDensity <- map["nodeDensity"]
        attachDamping <- map["attachDamping"]
        snapDamping <- map["snapDamping"]
    }
    
    func mapping(map: Map) {
        /// Mapping already completed in init()
    }
}
