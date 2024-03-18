//
//  CodableObject.swift
//  COFramework
//
//  Created by Ozkurt, Cenker on 3/16/24.
//

import Foundation

public class CodableObject: Codable {
    public var value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let strValue = try? container.decode(String.self) {
            value = strValue
        } else if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let dictValue = try? container.decode([String: CodableObject].self) {
            var decodedDict = [String: Any]()
            for (key, customDataValue) in dictValue {
                decodedDict[key] = customDataValue.value
            }
            value = decodedDict
        } else if let arrayValue = try? container.decode([CodableObject].self) {
            value = arrayValue.map { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "CustomData value cannot be decoded")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case let strValue as String:
            try container.encode(strValue)
        case let intValue as Int:
            try container.encode(intValue)
        case let boolValue as Bool:
            try container.encode(boolValue)
        case let doubleValue as Double:
            try container.encode(doubleValue)
        case let dictValue as [String: Any]:
            let encodedDict = dictValue.mapValues { CodableObject($0) }
            try container.encode(encodedDict)
        case let arrayValue as [Any]:
            try container.encode(arrayValue.map { CodableObject($0) })
        default:
            let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: "CustomData value cannot be encoded")
            throw EncodingError.invalidValue(value, context)
        }
    }
}
