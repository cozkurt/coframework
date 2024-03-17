//
//  JSONLoader.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/7/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import Foundation

open class FileLoader {

    /**
     loadFile loads custom json styles from file.
     
     - parameters:
     - fileName:
     - completion:
     */
    
    class func loadFile(fileName: String) throws -> String {
        return try self.loadFile(bundle: Bundle.main, fileName: fileName)
    }
    
    /**
     loadFile loads custom json styles from file.
     
     - parameters:
     - fileName:
     - completion:
     */
    
    class func loadFile(bundle: Bundle, fileName: String) throws -> String {
        
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            throw NSError(domain: "com.kp", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid filename!"])
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: Data.ReadingOptions.alwaysMapped)
        
        guard let dataString = String(data: data, encoding: String.Encoding.utf8) else {
            throw NSError(domain: "com.kp", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid contents!"])
        }
        
        return dataString
    }
}
