//
//  LanguageManager.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import Foundation

public enum CurrencyCode: String {
    case dollar = "en_US"
    case euro = "en_EU"
    
    var symbol: String {
        switch self {
        case .dollar:
            return "$"
        case .euro:
            return "€"
        }
    }
}

public class LanguageManager {
    
    // initial lang code from system
    var languageCode: String? = Locale.current.identifier
    
    //
    // MARK: - sharedInstance for singleton access
    //
    
    public static let sharedInstance: LanguageManager = LanguageManager()
    
    var currentIdentifier: String {
        return languageCode?.components(separatedBy: "_").first ?? "en"
    }
    
    var currentIdentifierLong: String {
        Locale.current.identifier
    }
    
    var currentLocale: Locale {
        return Locale(identifier: currentIdentifier)
    }
    
    var currentSymbol: String {
        return Locale.current.currencySymbol ?? ""
    }
    
    var currentRegion: String {
        return Locale.current.regionCode ?? ""
    }
    
    // MARK - helper methods
    
    func symbol(forCurrencyCode code: CurrencyCode) -> String {
        let locale = Locale(identifier: code.rawValue)
        return locale.currencySymbol ?? ""
    }
    
    func changeLanguage(with language: String) {
        self.languageCode = language
    }
}
