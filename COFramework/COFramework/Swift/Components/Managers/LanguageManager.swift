//
//  LanguageManager.swift
//  COFramework
//
//  Created by Cenker Ozkurt on 6/23/21.
//

import UIKit
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
    public var languageCode: String? = Locale.current.identifier
    
    //
    // MARK: - sharedInstance for singleton access
    //
    
    public static let sharedInstance: LanguageManager = LanguageManager()
    
    public var currentIdentifier: String {
        return languageCode?.components(separatedBy: "_").first ?? "en"
    }
    
    public var currentIdentifierLong: String {
        Locale.current.identifier
    }
    
    public var currentLocale: Locale {
        return Locale(identifier: currentIdentifier)
    }
    
    public var currentSymbol: String {
        return Locale.current.currencySymbol ?? ""
    }
    
    public var currentRegion: String {
        return Locale.current.regionCode ?? ""
    }
    
    public var currentLanguageString: String {
        
        let lang = self.currentIdentifier
        
        switch lang {
        case "en":
            return "English".localize()
        case "tr":
            return "Turkish".localize()
        case "ja":
            return "Japanese".localize()
        case "zh-Hans":
            return "Chinese".localize()
        case "nl":
            return "Dutch".localize()
        case "de":
            return "German".localize()
        case "fr":
            return "French".localize()
        case "es":
            return "Spanish".localize()
        case "ko":
            return "Korean".localize()
        default:
            return "English".localize()
        }
    }
    
    // MARK - helper methods
    
    public func symbol(forCurrencyCode code: CurrencyCode) -> String {
        let locale = Locale(identifier: code.rawValue)
        return locale.currencySymbol ?? ""
    }
    
    public func changeLanguage(with language: String) {
        self.languageCode = language
    }
}
