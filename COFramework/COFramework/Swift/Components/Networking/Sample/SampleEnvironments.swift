//
//  SampleEnvironments.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

public enum SampleEnvironments: String {

    case dev
    case qa
    case production

    var baseURL: String {
        switch self {
        case .dev: return ""
        case .qa: return ""
        case .production: return ""
        }
    }
}
