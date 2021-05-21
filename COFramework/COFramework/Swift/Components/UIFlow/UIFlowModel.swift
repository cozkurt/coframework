//
//  FlowModel.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit
import ObjectMapper

public enum UIFlowNavigationType: String {
    case push       // Push view controller to current navigation controller
    case pop        // Pops recent view controller
    case popTo      // Pop to given view controller
    case popToRoot  // Pop to root of navigation controller
    case dismiss    // Dismiss last presented view controller
    case dismissNC  // Dismiss last presented navigation controller
    case present    // Present view controller in current navigation controller
    case presentNC  // Present view controller in new navigation controller and make it root.
    case replace    // Replaces view controller to new given view controller
    case presentSubViewToRoot  // Add as subview to ROOT navigation controller
    case dismissSubViewFromRoot // Removes subview from ROOT navigation controller
    case presentSubView  // Add as subview to top navigation controller
    case dismissSubView // Removes subview from top navigation controller
    case dismissAll  // Dismiss all controllers in root view controller
    case removeAll   // Remove all controller from root view controller
}

struct UIFlowModel: Mappable {
    
    /// Model Properties

    var eventName: String?
    var eventMapTo: String?
    var storyBoard: String?
    var identifier: String?
    var viewController: String?
    var navigationType: UIFlowNavigationType?
    var modalPresentationStyle: UIModalPresentationStyle?
    var modalTransitionStyle: UIModalTransitionStyle?
	var transitionType: String?
    var navigationBar: Bool? // on/off navigation bar
    var statusBarStyle: String? // If status bar is on then apply status bar style "Default", "LightContent"
    var animated: Bool? // animation on/off
	var multiple: Bool? = false // allows to push same viewController

    // MARK: Mappable protocol conformance
    
    init?(map: Map) {
        
        // Model Properties
        eventName <- map["eventName"]
        eventMapTo <- map["eventMapTo"]
        storyBoard <- map["storyBoard"]
        identifier <- map["identifier"]
        viewController <- map["viewController"]
        navigationType <- map["navigationType"]
        modalPresentationStyle <- (map["modalPresentationStyle"], TransformOf<UIModalPresentationStyle, String>(fromJSON: { UIModalPresentationStyle(rawValue: Int($0!)!) }, toJSON: { $0.map { String(describing: $0) } }))
        modalTransitionStyle <- (map["modalTransitionStyle"], TransformOf<UIModalTransitionStyle, String>(fromJSON: { UIModalTransitionStyle(rawValue: Int($0!)!) }, toJSON: { $0.map { String(describing: $0) } }))
		transitionType <- map["transitionType"]
        navigationBar <- map["navigationBar"]
        statusBarStyle <- map["statusBarStyle"]
        animated <- map["animated"]
		multiple <- map["multiple"]
    }
    
    func mapping(map: Map) {
        /// Mapping already completed in init()
    }
}
