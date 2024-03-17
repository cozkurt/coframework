//
//  SampleModel.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation

public struct SampleModel: Codable {
    
    var id: String?
    var firstName: String?
    var lastName: String?

    // Custom CodingKeys to match the JSON keys with property names
    private enum CodingKeys: String, CodingKey {
        case id, firstName, lastName
    }
}

