//
//  LanguageManager.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
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
    var languageCode: String? = UserManager.sharedInstance.currentUserModel?.language ?? Locale.current.identifier
    
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
        
        let lang = LanguageManager.sharedInstance.currentIdentifier
        
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

extension LanguageManager {
    
    func showLanguagesActionSheet(viewController: UIViewController?, _ callback: (() -> ())?) {
        
        guard let viewController = viewController else {
            return
        }
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: UIDevice().preferredStyle())
        
        alert.addAction(UIAlertAction(title: "English".localize(), style: .default) { _ in
            self.changeLanguage(language: "en", callback)
        })
        
        alert.addAction(UIAlertAction(title: "Chinese".localize(), style: .default) { _ in
            self.changeLanguage(language: "zh-Hans", callback)
        })
        
        alert.addAction(UIAlertAction(title: "Dutch".localize(), style: .default) { _ in
            self.changeLanguage(language: "nl", callback)
        })
        
        alert.addAction(UIAlertAction(title: "French".localize(), style: .default) { _ in
            self.changeLanguage(language: "fr", callback)
        })
        
        alert.addAction(UIAlertAction(title: "German".localize(), style: .default) { _ in
            self.changeLanguage(language: "de", callback)
        })
        
        alert.addAction(UIAlertAction(title: "Japanese".localize(), style: .default) { _ in
            self.changeLanguage(language: "ja", callback)
        })
        
        alert.addAction(UIAlertAction(title: "Korean".localize(), style: .default) { _ in
            self.changeLanguage(language: "ko", callback)
        })
        
        alert.addAction(UIAlertAction(title: "Spanish".localize(), style: .default) { _ in
            self.changeLanguage(language: "es", callback)
        })
        
        alert.addAction(UIAlertAction(title: "Turkish".localize(), style: .default) { _ in
            self.changeLanguage(language: "tr", callback)
        })

        alert.addAction(UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: nil))
        
        runOnMainQueue {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func changeLanguage(language: String, _ callback: (() -> ())?) {
        
        let currentUserModel = UserManager.sharedInstance.currentUserModel
        
        AppPersistence.languageCode = language
        LanguageManager.sharedInstance.changeLanguage(with: language)
        
        // save to userModel
        currentUserModel?.language = LanguageManager.sharedInstance.currentIdentifier
        currentUserModel?.save({
            
            runOnMainQueue(after: 0.3) {
                // notify menu items to reload for changes language
                MenuViewController.updateMenuBadges.notify()
                
                // Notify Home view to reload
                HomeViewController.refreshSearchEvent.notify()
                
                // notify caller
                callback?()
            }
        })
    }
}
