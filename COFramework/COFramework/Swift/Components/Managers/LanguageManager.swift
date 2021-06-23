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
    
    var currentLanguageString: String {
        
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
    
    func symbol(forCurrencyCode code: CurrencyCode) -> String {
        let locale = Locale(identifier: code.rawValue)
        return locale.currencySymbol ?? ""
    }
    
    func changeLanguage(with language: String) {
        self.languageCode = language
    }
}
