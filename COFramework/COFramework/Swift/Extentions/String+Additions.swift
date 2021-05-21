//
//  String+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit
import Foundation

extension String {
    
    func trimWhitespace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func indexOf(_ substring: String) -> Int? {
        if let range = range(of: substring) {
            return self.distance(from: startIndex, to: range.lowerBound)
        }
        return nil
    }
    
    func substring(_ startIndex: Int, length: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: startIndex)
        let end = self.index(self.startIndex, offsetBy: startIndex + length)
        return String(self[start..<end])
    }
    
    subscript(i: Int) -> Character {
        get {
            let index = self.index(self.startIndex, offsetBy: i)
            return self[index]
        }
    }
    
    func split(_ separator: Character) -> [String] {
        return self.split{$0 == separator}.map(String.init)
    }
    
    func doubleValue() -> Double? {
        let result = self.filter("0123456789.,".contains)
        
        return Double(result)
    }
	
    var firstWord: String {
        return self.components(separatedBy: " ").first ?? ""
    }
    
    var lastWord: String {
        return self.components(separatedBy: " ").last ?? ""
    }
    
    var hasValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    var hasValidCharacters: Bool {
        return hasValidEmojiCharacters || hasValidPasswordCharacters
    }
    
    var hasValidEmojiCharacters: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case
            0x200D...0x200D, // Zero width joiner
            0x20D0...0x20FF, // Combining Diacritical Marks for Symbols
            0x2300...0x23FF, // Miscellaneous Technical
            0x2B00...0x2BFF, // Miscellaneous Symbols and Arrows
            0x25A0...0x25FF, // Geometric Shapes
            0x2600...0x26FF, // Miscellaneous Symbols
            0x2700...0x27BF, // Dingbats
            0xFE00...0xFE0F, // Variation Selectors
            0x1F000...0x1F02F, // Mahjong Tiles
            0x1F030...0x1F09F, // Domino Tiles
            0x1F0A0...0x1F0FF, // Playing Cards
            0x1F100...0x1F1FF, // Enclosed Alphanumeric Supplement
            0x1F300...0x1F5FF, // Miscellaneous Symbols and Pictographs
            0x1F600...0x1F64F, // Emoticons
            0x1F680...0x1F6FF, // Transport and Map Symbols
            0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
    var hasValidPasswordCharacters: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case
            0x20...0x7E:  // valid ASCII characters
                return true
            default:
                continue
            }
        }
        return false
    }
	
	var passwordStrength: Int {
		// return 0: weak, 1: medium, 2: strong
		// minimum 8 characters
		
		if self.count < 8 {
			return 0
		}
		
		var strength = 0
		
		// Uppercase
		if self.range(of: "[A-Z]", options: .regularExpression) != nil {
			strength += 1
		}
		
		if self.range(of: "[a-z]", options: .regularExpression) != nil {
			strength += 1
		}
		
		if self.rangeOfCharacter(from: .decimalDigits) != nil {
			strength += 1
		}
		
		let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
		if self.rangeOfCharacter(from: characterset.inverted) != nil {
			strength += 1
		}
		
		// strength 4: strong, 3: medium, 2 or less: weak.
		return (strength == 4) ? 2 : (strength == 3) ? 1 : 0
	}
    
    func relativeDateString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        
        return date.relativeDateString()
    }
	
	// Version compare
	func compareTo(_ version: String) -> ComparisonResult {
		return self.compare(version, options: NSString.CompareOptions.numeric, range: nil, locale: nil)
	}
	
	func newerThan(_ version: String) -> Bool {
		return (self.compareTo(version) == .orderedDescending)
	}
	
	func truncate(_ length: Int, trailing: String? = "\u{2026}") -> String {
		if self.count > length {
			return self.prefix(upTo: self.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
		} else {
			return self
		}
	}
    
    var capitalizeFirstWord: String {
        if self.count == 0 {
            return self
        }
        
        return String(self[self.startIndex]).localizedCapitalized + String(self.dropFirst())
    }
    
    var capitalizeFirstLetter: String {
        if self.count == 0 {
            return self
        }
        
        return String(self[self.startIndex]).localizedCapitalized
    }
    
    var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            return try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSMutableAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func limit(size: Int) -> String {
        var locationName = String(self.prefix(size))
        if self.count > size {
            locationName += "..."
        }
        
        return locationName
    }

	func stringSize(withFontName fontName: String, size: CGFloat) -> CGSize {

		var font: UIFont?
		
		if fontName.lowercased() == "system" {
			font = UIFont.systemFont(ofSize: size)
		} else {
			font = UIFont(name: fontName, size: size)  ?? UIFont.systemFont(ofSize: size)
		}
		
		if let font = font {
			return self.size(withAttributes: [NSAttributedString.Key.font: font])
		} else {
			return CGSize.zero
		}
	}
    
    func markdownStyleLinks() -> [(String, String)] {
        var inLink:Bool = false
        var inLinkText:Bool = false
        
        var currentLink:String = ""
        var currentLinkText:String = ""
        var links:[(String, String)] = []
        
        for char in self {
            
            switch (char) {
            case "[":
                inLink = true
                inLinkText = true
                break
            case "]":
                inLinkText = false
                break
            case ")":
                inLink = false
                currentLink.append(char)
                links.append((currentLink, currentLinkText))
                currentLink = ""
                currentLinkText = ""
                break
            default:
                break
            }
            
            if (inLink) {
                currentLink.append(char)
            }
            
            if (inLinkText && char != "]" && char != "[") {
                currentLinkText.append(char)
            }
        }
        
        return links
    }
    
    func validateAsEntry() -> Bool {
        if (self.isEmpty) {
            return false
        }
        
        guard let justSpacesRange = self.range(of: "[ ]*", options: .regularExpression) else {
            return true
        }
        
        return self[justSpacesRange] != self
    }
    
    func asFontWeight() -> UIFont.Weight {
    
        switch self {
            
        case "Bold":
            return UIFont.Weight.bold
            
        case "Light":
            return UIFont.Weight.light
            
        case "Medium":
            return UIFont.Weight.medium
            
        case "Regular":
            return UIFont.Weight.regular
            
        default:
            return UIFont.Weight.regular
        }
    }
    
    public func toData() -> Data? {
        return Data(base64Encoded: self)
    }
}
