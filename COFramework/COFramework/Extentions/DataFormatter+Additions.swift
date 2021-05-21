//
//  DataFormatter+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    @objc func isWithin24hrs(offlineSince: String) -> Bool {
        self.timeZone = TimeZone(abbreviation: "UTC")!
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
      
        guard let date = self.date(from: offlineSince) else {
            return false
        }
        let hours = Date().hoursFrom(date, timeZoneString: "UTC")
        if hours < 24 {
            return true
        }
        return false
    }
}
