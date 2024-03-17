//
//  FlowModel.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

public enum UIFlowNavigationType: String, Codable {
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

struct UIFlowModel: Codable {
    
    var instanceName: String?
    var eventName: String?
    var eventMapTo: String?
    var storyBoard: String?
    var identifier: String?
    var viewController: String?
    var navigationType: UIFlowNavigationType?
    var modalPresentationStyle: UIModalPresentationStyle?
    var modalTransitionStyle: UIModalTransitionStyle?
    var transitionType: String?
    var navigationBar: Bool?
    var statusBarStyle: String?
    var animated: Bool?
    var multiple: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case instanceName, eventName, eventMapTo, storyBoard, identifier, viewController, navigationType, transitionType, navigationBar, statusBarStyle, animated, multiple, modalPresentationStyle, modalTransitionStyle
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode simple types
        instanceName = try container.decodeIfPresent(String.self, forKey: .instanceName)
        eventName = try container.decodeIfPresent(String.self, forKey: .eventName)
        eventMapTo = try container.decodeIfPresent(String.self, forKey: .eventMapTo)
        storyBoard = try container.decodeIfPresent(String.self, forKey: .storyBoard)
        identifier = try container.decodeIfPresent(String.self, forKey: .identifier)
        viewController = try container.decodeIfPresent(String.self, forKey: .viewController)
        transitionType = try container.decodeIfPresent(String.self, forKey: .transitionType)
        navigationBar = try container.decodeIfPresent(Bool.self, forKey: .navigationBar)
        statusBarStyle = try container.decodeIfPresent(String.self, forKey: .statusBarStyle)
        animated = try container.decodeIfPresent(Bool.self, forKey: .animated)
        multiple = try container.decodeIfPresent(Bool.self, forKey: .multiple)

        // Decode custom types
        navigationType = try container.decodeIfPresent(UIFlowNavigationType.self, forKey: .navigationType)
        
        if let modalPresentationStyleString = try container.decodeIfPresent(String.self, forKey: .modalPresentationStyle), let styleValue = Int(modalPresentationStyleString) {
            modalPresentationStyle = UIModalPresentationStyle(rawValue: styleValue)
        } else {
            modalPresentationStyle = nil
        }
        
        if let modalTransitionStyleString = try container.decodeIfPresent(String.self, forKey: .modalTransitionStyle), let styleValue = Int(modalTransitionStyleString) {
            modalTransitionStyle = UIModalTransitionStyle(rawValue: styleValue)
        } else {
            modalTransitionStyle = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(instanceName, forKey: .instanceName)
        // Continue with other properties...
        if let modalPresentationStyle = modalPresentationStyle {
            try container.encodeIfPresent(String(describing: modalPresentationStyle.rawValue), forKey: .modalPresentationStyle)
        }
        if let modalTransitionStyle = modalTransitionStyle {
            try container.encodeIfPresent(String(describing: modalTransitionStyle.rawValue), forKey: .modalTransitionStyle)
        }
    }
}
