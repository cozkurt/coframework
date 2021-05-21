//
//  DictionaryHelper.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 01/06/20.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation

protocol DictionaryHelper {
    func toDict() -> [String:String]
    func JSONString() -> String?
}

extension DictionaryHelper {
    
    func toDict() -> [String:String] {
        var dict = [String:String]()
        let otherSelf = Mirror(reflecting: self)
        
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = "\(child.value)"
            }
        }
        return dict
    }
    
    func JSONString() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self.toDict(), options: JSONSerialization.WritingOptions(rawValue: UInt(0)))
            return String(data: jsonData, encoding: String.Encoding.utf8)
        } catch let error {
            print("error converting to json: \(error)")
            return nil
        }
    }
}
