//
//  Mappable+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/22/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit
import CloudKit
import ObjectMapper

extension NSObject {
    
    public var record: CKRecord {
        let className = String(describing: type(of: self))
        let record = CKRecord(recordType: className, recordID: CKRecord.ID(recordName: UUID().uuidString))

        for key in Mirror(reflecting: self).children.compactMap({ $0.label }) {
            if let value = self[key] {
                if value is UIImage {
                    record[key] = CKAsset(image: value as! UIImage, size: UIScreen.main.bounds.width, compression: 0.8)
                } else {
                    record.setValue(value, forKey: key)
                }
            }
        }

        return record
    }
    
    subscript(key: String) -> Any? {
        let m = Mirror(reflecting: self)
        return m.children.first { $0.label == key }?.value
    }
}
