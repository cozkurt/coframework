//
//  AppearanceModel.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import ObjectMapper

public struct AppearanceModel: Mappable {
    
    /// Model Properties
    
    /// Unique ID that needs to be defined accross the App
    /// We need to load on set of UI definitions in JSON file
    /// This is needs to be defined in UIButton that extends
    /// AppearanceButton and other UI object
    /// values : "appearance" or "<any uniqe name>"
    /// if value is "appearance" then it will apply to Appreance proxy
    var appearanceId: String?
    
    /// appearanceType is a UI type of the component to apply
    /// rest of the properties
    /// values: "button", "label" (will be added more)
    var appearanceType: String?
    
    /// For applying to appearance when contained in class
    var appearanceWhenContainedInClass: String?
    
    /// format : "top,left,bottom,right"
    var contentEdgeInsets: String?
    
    /// format : "r,g,b,a"
    var textColor: String?
    
    /// format : "r,g,b,a"
    var titleColor: String?
    
    /// values : "normal", "highlighted", "disabled", "selected"
    var titleColorState: String?
    
    /// format : "r,g,b,a"
    var titleShadowColor: String?
    
    /// values : "normal", "highlighted", "disabled", "selected"
    var titleShadowColorState: String?
    
    /// format : "fileName.png"
    var backgroundImage: String?
    
    /// values : "normal", "highlighted", "disabled", "selected"
    var backgroundImageState: String?
    
    /// format : "r,g,b,a"
    var backgroundColor: String?
    
    /// format : "r,g,b,a"
    var tintColor: String?
    
    /// values "font-name, font-size" ex: "HelveticaNeue,16"
    var font: String?
    
    /// flag for button width to match text size
    var sizeToFitWidth: Bool?
    
    // MARK: CALayer Properties to apply UI Objects
    
    /// format : "r,g,b,a" to applyt CALayer
    var borderColor: String?
    
    /// format : "(float)"
    var borderWidth: String?
    
    /// format : "(float)"
    var cornerRadius: String?
    
    /// format : "r,g,b,a" to applyt CALayer
    var shadowColor: String?
    
    /// format : "(float)"
    var shadowRadius: String?
    
    /// format : "(float)"
    var numberOfLines: String?
    
    /// format : "(float)" NSMutableParagraphStyle lineSpacing value
    var styleLineSpacing: String?
    
    /// format : "(float)" NSMutableParagraphStyle alignment value
    var styleAlignment: String?
    
    /// format : "(Int)" NSLineBreakMode linebreak style value
    var styleLinebreak: String?
    
    /// format : "[color: hex]" array
    var colors: [ColorsMap]?
    
    /// format : "r,g,b,a"  Used for UISegmentedControl only
    var selectedTextColor: String?
    
    /// format: true/false  Used for UISegmentedControl only
    var removeDividers: Bool?
    
    // MARK: Mappable protocol conformance
    
    public init?(map: Map) {
        
        // Model Properties
        appearanceId <- map["appearanceId"]
        appearanceType <- map["appearanceType"]
        
        appearanceWhenContainedInClass <- map["appearanceWhenContainedInClass"]
        
        // UIComponent Properties
        contentEdgeInsets <- map["contentEdgeInsets"]
        
        tintColor <- map["tintColor"]
        textColor <- map["textColor"]
        
        titleColor <- map["titleColor"]
        titleColorState <- map["titleColorState"]
        
        titleShadowColor <- map["titleShadowColor"]
        titleShadowColorState <- map["titleShadowColorState"]
        
        backgroundImage <- map["backgroundImage"]
        backgroundImageState <- map["backgroundImageState"]
        
        backgroundColor <- map["backgroundColor"]
        
        font <- map["font"]
        
        sizeToFitWidth <- map["sizeToFitWidth"]
        
        borderColor <- map["borderColor"]
        borderWidth <- map["borderWidth"]
        
        cornerRadius <- map["cornerRadius"]
        
        shadowColor <- map["shadowColor"]
        shadowRadius <- map["shadowRadius"]
        
        numberOfLines <- map["numberOfLines"]
        
        styleLineSpacing <- map["styleLineSpacing"]
        styleAlignment <- map["styleAlignment"]
        styleLinebreak <- map["styleLinebreak"]
        
        colors <- map["colors"]
        
        selectedTextColor <- map["selectedTextColor"]
        removeDividers <- map["removeDividers"]
    }
    
    public func mapping(map: Map) {
        /// Mapping already completed in init()
    }
}

public struct ColorsMap: Mappable {
    
    var name: String?
    var value: String?
    
    // MARK: Mappable protocol conformance
    
    public init?(map: Map) {
        name <- map["name"]
        value <- map["value"]
    }
    
    public func mapping(map: Map) {
        /// Mapping already completed in init()
    }
}
