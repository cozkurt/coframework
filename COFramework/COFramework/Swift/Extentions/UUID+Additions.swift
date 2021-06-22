//
//  UUID+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 4/20/20.
//  Copyright © 2020 FuzFuz. All rights reserved.
//

import CommonCrypto
import Foundation
import CloudKit

extension UUID {

    enum UUIDv5NameSpace: String {
        case dns  = "6ba7b810-9dad-11d1-80b4-00c04fd430c8"
        case url  = "6ba7b811-9dad-11d1-80b4-00c04fd430c8"
        case oid  = "6ba7b812-9dad-11d1-80b4-00c04fd430c8"
        case x500 = "6ba7b814-9dad-11d1-80b4-00c04fd430c8"
    }

    init(hashing value: String, namespace: UUIDv5NameSpace) {
        var context = CC_SHA1_CTX()
        CC_SHA1_Init(&context)

        _ = withUnsafeBytes(of: UUID(uuidString: namespace.rawValue)!.uuid) { (buffer) in
            CC_SHA1_Update(&context, buffer.baseAddress, CC_LONG(buffer.count))
        }

        _ = value.withCString { (cString) in
            CC_SHA1_Update(&context, cString, CC_LONG(strlen(cString)))
        }

        var array = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1_Final(&array, &context)

        array[6] = (array[6] & 0x0F) | 0x50 // set version number nibble to 5
        array[8] = (array[8] & 0x3F) | 0x80 // reset clock nibbles
        
        // truncate to first 16
        self.init(uuid: (array[0], array[1], array[2], array[3],
                         array[4], array[5], array[6], array[7],
                         array[8], array[9], array[10], array[11],
                         array[12], array[13], array[14], array[15]))
    }
    
    var shortuuid: String {
        return self.uuidString.components(separatedBy: "-").first ?? ""
    }
    
    func uuidHashed(ids: [CKRecord.ID]) -> String {
        // sum of all hashValues, 1000 is arbitary number just to prevent aritmetic error
        let allHashValues = ids.compactMap({abs($0.hashValue/1000)}).reduce(0, +)
        
        return UUID(hashing: "\(allHashValues)", namespace: .x500).uuidString
    }
}
