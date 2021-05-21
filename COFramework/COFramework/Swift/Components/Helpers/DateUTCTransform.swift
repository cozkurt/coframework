//
//  DateUTCTransform.swift
//  Lystit
//
//  Created by Cenker Ozkurt on 7/1/20.
//  Copyright © 2020 FuzFuz. All rights reserved.
//

import Foundation
import ObjectMapper

open class DateUTCTransform: TransformType {
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Date? {
        if let timeStr = value as? String {
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            if let date = dateFormatter.date(from: timeStr) {
                return date
            }
        }
        
        return nil
    }
    
    open func transformToJSON(_ value: Date?) -> String? {
        return nil
    }
}
