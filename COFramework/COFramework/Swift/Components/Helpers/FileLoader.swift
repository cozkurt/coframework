//
//  FileLoader.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/7/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import ObjectMapper
import Foundation

open class FileLoader {

    /**
     loadFile loads custom json styles from file.
     
     - parameters:
     - fileName:
     - completion:
     */
    
    class func load(_ fileName: String, ofType: String = "json") throws -> String {
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: ofType) else {
            throw NSError(domain: "com.FuzFuz", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid filename!"])
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: Data.ReadingOptions.alwaysMapped)
        
        guard let dataString = String(data: data, encoding: String.Encoding.utf8) else {
            throw NSError(domain: "com.FuzFuz", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid contents!"])
        }
        
        return dataString
    }
}
