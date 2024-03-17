//
//  AppearanceController.swift
//  COLibrary
//
//  Created by Cenker Ozkurt on 07/14/16.
//  Copyright (c) 2015 Cenker Ozkurt. All rights reserved.
//

import UIKit
import Foundation

public class AppearanceController {
    
    /// json file to load into model
    var fileName: String?
    
    /// helper class instance
    var appearanceHelpers = AppearanceHelpers()
    
    /// Models in array
    var appearanceModels = [AppearanceModel]()
    
    // MARK: - Init Methods
    
    fileprivate init() {}
    
    //
    // MARK: - sharedInstance for singleton access
    //
    public static let sharedInstance: AppearanceController = AppearanceController()
    
    // MARK: - Public Methods
    
    /**
     loadAppearance load predefined modals and applies to
     appearanceModals array.
     
     - parameters:
     - fileName: json array for UI components.
     - view: uiview if oprovided it will apply styles to that view.
     - append: Bool if true then adds new models to previous onces
     */
    
    public func loadAppearance(_ fileName: String, view: UIView? = nil, append: Bool = true) {
        self.fileName = fileName
        
        if let jsonString = try? FileLoader.loadFile(fileName: fileName), let jsonData = jsonString.data(using: .utf8) {
            do {
                // Use JSONDecoder to decode the JSON string into an array of AppearanceModel objects
                let decoder = JSONDecoder()
                let appearanceModels = try decoder.decode([AppearanceModel].self, from: jsonData)
                
                if append {
                    // add to previous models
                    self.appearanceModels.append(contentsOf: appearanceModels)
                } else {
                    // reset previous models
                    self.appearanceModels = appearanceModels
                }
                
                // apply all appearance models to classes
                self.applyModelsToAppearance()
                
                // apply models if view submitted
                // this is used specially when loading new json file
                // to apply to view in real-time
                if let view = view {
                    self.applyModelsToView(view)
                }
                
            } catch {
                // Handle JSON decoding error
                print("Error decoding AppearanceModel from file: \(fileName), error: \(error)")
            }
        }
    }

    
    /**
     color search for color from json.
     
     - parameters:
     - colorName: Name of the color from json
     - defaultColor: if color not found then return defaultColor (default is red)
     */
    
    public func color(_ colorName: String, defaultColor: UIColor = UIColor.red) -> UIColor {
        return self.appearanceHelpers.searchColorMap(colorName) ?? defaultColor
    }
    
    /**
     customizeView Applies appearanceModal to given AppearanceView.
     AppearanceView should have "appearanceId" setup in interface builder to
     
     - parameters:
     - button: AppearanceView that will apply the style
     
     sample json :
     {
     "appearanceId": "CustomView",
     "appearanceType": "view",
     "backgroundColor": "0,0,255,1",
     "tintColor": "0,0,255,1"
     }
     */
    
    public func customizeView(_ view: AppearanceView) {
        
        let models = self.appearanceModels.filter { $0.appearanceId == view.appearanceId }
        
        if let model = models.last {
            self.applyToView(model, view: view as UIView)
        }
    }
    
    /**
     customizeButton Applies appearanceModal to given AppearanceButton.
     AppearancButton should have "appearanceId" setup in interface builder to
     
     - parameters:
     - button: AppearanceButton that will apply the style
     
     sample json :
     {
     "appearanceId": "OkButton",
     "appearanceType": "button",
     "contentEdgeInsets": "0,0,0,0",
     "titleColor": "0,0,255,1",
     "titleColorState": "Normal"
     },     {
     "appearanceId": "OkButton",
     "appearanceType": "button",
     "contentEdgeInsets": "0,0,0,0",
     "titleColor": "0,255,255,1",
     "titleColorState": "Selected"
     }
     */
    
    public func customizeButton(_ button: AppearanceButton) {
        
        let models = self.appearanceModels.filter { $0.appearanceId == button.appearanceId }
        
        if let model = models.last {
            self.applyToButton(model, button: button as UIButton)
        }
    }
    
    /**
     customizeButton Applies appearanceModal to given AppearanceButton.
     AppearancButton should have "appearanceId" setup in interface builder to
     
     - parameters:
     - button: AppearanceButton that will apply the style
     
     sample json :
     {
     "appearanceId": "CustomLabel",
     "appearanceType": "label",
     "textColor": "0,255,0,1",
     "backgroundColor": "0,0,255,1",
     "font": "HelveticaNeue,20"
     }
     */
    
    public func customizeLabel(_ label: AppearanceLabel) {
        
        let models = self.appearanceModels.filter { $0.appearanceId == label.appearanceId }
        
        if let model = models.last {
            self.applyToLabel(model, label: label as UILabel)
        }
    }
    
    /**
     customizeTextView Applies appearanceModal to given AppearanceTextView.

     - parameters:
     - button: AppearanceTexView that will apply the style
     
     sample json :
     {
     "appearanceId": "CustomTextView",
     "appearanceType": "textView",
     "textColor": "0,255,0,1",
     "backgroundColor": "0,0,255,1",
     "font": "HelveticaNeue,20"
     }
     */

    public func customizeTextView(_ textView: AppearanceTextView) {
        
        let models = self.appearanceModels.filter { $0.appearanceId == textView.appearanceId }
        
        if let model = models.last {
            self.applyToTextView(model, textView: textView as UITextView)
        }
    }
    
    /**
     customizeTextField Applies appearanceModal to given AppearanceTextField.
     
     - parameters:
     - button: AppearanceTexView that will apply the style
     
     sample json :
     {
     "appearanceId": "CustomTextField",
     "appearanceType": "textField",
     "textColor": "0,255,0,1",
     "backgroundColor": "0,0,255,1",
     "font": "HelveticaNeue,20"
     }
     */
    
    public func customizeTextField(_ textField: AppearanceTextField) {
        
        let models = self.appearanceModels.filter { $0.appearanceId == textField.appearanceId }
        
        if let model = models.last {
            self.applyToTextField(model, textField: textField as UITextField)
        }
    }
    
    /**
     customizeSegmentedControl Applies appearanceModal to given AppearanceSegmented.
     
     - parameters:
     - button: AppearanceTexView that will apply the style
     
     sample json :
     {
     "appearanceId": "CustomSegmentedControl",
     "appearanceType": "segmentedControl",
     "textColor": "0,255,0,1",
     "backgroundColor": "0,0,255,1",
     "font": "HelveticaNeue,20"
     }
     */
    
    public func customizeSegmentedControl(_ segmentedControl: AppearanceSegmented) {
        
        let models = self.appearanceModels.filter { $0.appearanceId == segmentedControl.appearanceId }
        
        if let model = models.last {
            self.applyToSegmentedControl(model, segmentedControl: segmentedControl as UISegmentedControl)
        }
    }
    
    /**
     customizeSwitch Applies appearanceModal to given AppearanceSwitch
     
     - parameters:
     - switch: AppearanceSwitch that will apply the style
     
     sample json :
     {
     "appearanceId": "CustomSwitch",
     "appearanceType": "switch",
     "backgroundColor": "0,0,255,1",
     "tintColor": "0,0,255,1"
     }
     */
    
    public func customizeSwitch(_ switchUI: AppearanceSwitch) {
        
        let models = self.appearanceModels.filter { $0.appearanceId == switchUI.appearanceId }
        
        if let model = models.last {
            self.applyToSwitch(model, switchUI: switchUI as UISwitch)
        }
    }
    
    /*
    sample json :
    {
    "appearanceId": "CustomImageView",
    "appearanceType": "imageView",
    "backgroundColor": "0,0,255,1",
    "titleColor": "0,0,255,1",
    "tintColor": "0,0,255,1",
    "cornerRadius": "5"
    }
    */
    
    public func customizeImageView(_ imageView: AppearanceImageView) {
        
        let models = self.appearanceModels.filter { $0.appearanceId == imageView.appearanceId }
        
        if let model = models.last {
            self.applyToImageView(model, imageView: imageView as UIImageView)
        }
    }
    
    /**
     applyModelsToView apply current loaded models to all
     objects in view.
     
     - parameters:
     - view: View to apply appearance settings realtime
     */
    
    public func applyModelsToView(_ view: UIView?) {
        
        guard let view = view else {
            return
        }
        
        /// find views and apply styles
        let views = view.subviews.filter({$0.isKind(of: AppearanceView.self)})
        
        for view in views {
            for appearanceModel in self.appearanceModels {
                
                if let appearanceId = appearanceModel.appearanceId, let view = view as? AppearanceView {
                    if view.appearanceId == appearanceId {
                        self.applyToView(appearanceModel, view: view)
                    }
                }
            }
        }
        
        /// find buttons and apply styles
        let buttons = view.subviews.filter({$0.isKind(of: AppearanceButton.self)})
        
        for button in buttons {
            for appearanceModel in self.appearanceModels {
                
                if let appearanceId = appearanceModel.appearanceId, let button = button as? AppearanceButton {
                    if button.appearanceId == appearanceId {
                        self.applyToButton(appearanceModel, button: button)
                    }
                }
            }
        }
        
        /// find buttons and apply styles
        let labels = view.subviews.filter({$0.isKind(of: AppearanceLabel.self)})
        
        for label in labels {
            for appearanceModel in self.appearanceModels {
                
                if let appearanceId = appearanceModel.appearanceId, let label = label as? AppearanceLabel {
                    if label.appearanceId == appearanceId {
                        self.applyToLabel(appearanceModel, label: label)
                    }
                }
            }
        }
        
        /// find textField and apply styles
        let textFields = view.subviews.filter({$0.isKind(of: AppearanceTextField.self)})
        
        for textField in textFields {
            for appearanceModel in self.appearanceModels {
                
                if let appearanceId = appearanceModel.appearanceId, let textField = textField as? AppearanceTextField {
                    if textField.appearanceId == appearanceId {
                        self.applyToTextField(appearanceModel, textField: textField)
                    }
                }
            }
        }
        
        /// find textView and apply styles
        let textViews = view.subviews.filter({$0.isKind(of: AppearanceTextView.self)})
        
        for textView in textViews {
            for appearanceModel in self.appearanceModels {
                
                if let appearanceId = appearanceModel.appearanceId, let textView = textView as? AppearanceTextView {
                    if textView.appearanceId == appearanceId {
                        self.applyToTextView(appearanceModel, textView: textView)
                    }
                }
            }
        }
        
        /// find segmentedControls and apply styles
        let segmentedControls = view.subviews.filter({$0.isKind(of: AppearanceSegmented.self)})
        
        for segmentedControl in segmentedControls {
            for appearanceModel in self.appearanceModels {
                
                if let appearanceId = appearanceModel.appearanceId, let segmentedControl = segmentedControl as? AppearanceSegmented {
                    if segmentedControl.appearanceId == appearanceId {
                        self.applyToSegmentedControl(appearanceModel, segmentedControl: segmentedControl)
                    }
                }
            }
        }
        
        /// find switch and apply styles
        let switchUIs = view.subviews.filter({$0.isKind(of: AppearanceSwitch.self)})
        
        for switchUI in switchUIs {
            for appearanceModel in self.appearanceModels {
                
                if let appearanceId = appearanceModel.appearanceId, let switchUI = switchUI as? AppearanceSwitch {
                    if switchUI.appearanceId == appearanceId {
                        self.applyToSwitch(appearanceModel, switchUI: switchUI)
                    }
                }
            }
        }
    }
    
    /**
     applyModelsToAppearance applies all styling from models to ui components.
     If appreanceID is "Appearance" then it applies to UIAppereance for that component.
     Otherwise it applies to actual component.
     */
    
    public func applyModelsToAppearance() {
        
        for appearanceModel in self.appearanceModels {
            
            if let appearanceId = appearanceModel.appearanceId {
                
                if appearanceId.lowercased() == "appearance" {
                    
                    self.applyToViewAppearance(appearanceModel)
                    self.applyToButtonAppearance(appearanceModel)
                    self.applyToLabelAppearance(appearanceModel)
                    self.applyToTextViewAppearance(appearanceModel)
                    self.applyToTextFieldAppearance(appearanceModel)
                    self.applyToSwitchAppearance(appearanceModel)
                    self.applyToSegmentedControlAppearance(appearanceModel)
                }
            }
        }
        
        self.refreshViews()
    }
    
    /**
     refreshViews reset all views to see appearance proxy changes realtime
     
     - parameters:
     */
    
    public func refreshViews() {
        
        let windows = UIApplication.shared.windows as [UIWindow]
        
        for window in windows {
            let subviews = window.subviews as [UIView]
            for v in subviews {
                v.removeFromSuperview()
                window.addSubview(v)
                
                self.applyModelsToView(v)
            }
        }
    }
    
    /**
     applyToView apply current
     model to label object
     
     - parameters:
     - appearanceModel: model to apply styles.
     - label: UILabel to apply styles.
     */
    
    public func applyToView(_ appearanceModel: AppearanceModel, view: UIView?) {
        
        /// check if appearanceType is "button"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "view" {
                return
            }
        }
        
        if let backgroundColor = appearanceModel.backgroundColor, let color = appearanceHelpers.convertToUIColor(backgroundColor) {
            view?.backgroundColor = color
        }
        
        if let tintColor = appearanceModel.tintColor, let color = appearanceHelpers.convertToUIColor(tintColor) {
            view?.tintColor = color
        }
        
        self.applyToCALayer(appearanceModel, layer: view?.layer)
    }
    
    /**
     applyToViewAppearance apply current
     model to view appearance proxy object
     
     - parameters:
     - appearanceModel: model to apply styles.
     */
    
    public func applyToViewAppearance(_ appearanceModel: AppearanceModel) {
        
        /// check if appearanceType is "view"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "view" {
                return
            }
        }
        
        let view: UIView?
        
        if let appearanceWhenContainedIn = appearanceModel.appearanceWhenContainedInClass, let aClass = NSClassFromString(appearanceWhenContainedIn) {
            view = UIView.appearance(whenContainedInInstancesOf: [aClass as! UIAppearanceContainer.Type])
        } else {
            view = UIView.appearance()
        }
        
        self.applyToView(appearanceModel, view: view)
    }
    
    /**
     applyToLabel apply current
     model to label object
     
     - parameters:
     - appearanceModel: model to apply styles.
     - label: UILabel to apply styles.
     */
    
    public func applyToLabel(_ appearanceModel: AppearanceModel, label: UILabel?) {
        
        /// check if appearanceType is "button"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "label" {
                return
            }
        }
        
        if let numberOfLines = appearanceModel.numberOfLines, let lines = Int(numberOfLines) {
            label?.numberOfLines = lines
        } else {
            label?.numberOfLines = 0
        }
        
        if let text = label?.text {
            label?.attributedText = self.applyStyle(appearanceModel, text: text)
        }
        
        if let backgroundColor = appearanceModel.backgroundColor, let color = appearanceHelpers.convertToUIColor(backgroundColor) {
            label?.backgroundColor = color
        }
        
        if let tintColor = appearanceModel.tintColor, let color = appearanceHelpers.convertToUIColor(tintColor) {
            label?.tintColor = color
        }
        
        if let font = appearanceModel.font, let uiFont = appearanceHelpers.convertToUIFont(font) {
            label?.font = uiFont
        }
        
        if let textColor = appearanceModel.textColor, let color = appearanceHelpers.convertToUIColor(textColor) {
            label?.textColor = color
        }
        
        self.applyToCALayer(appearanceModel, layer: label?.layer)
    }
    
    /**
     applyToLabelAppearance apply current
     model to label appearance proxy object
     
     - parameters:
     - appearanceModel: model to apply styles.
     */
    
    public func applyToLabelAppearance(_ appearanceModel: AppearanceModel) {
        
        /// check if appearanceType is "label"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "label" {
                return
            }
        }
        
        let label: UILabel?
        
        if let appearanceWhenContainedIn = appearanceModel.appearanceWhenContainedInClass, let aClass = NSClassFromString(appearanceWhenContainedIn) {
            label = UILabel.appearance(whenContainedInInstancesOf: [aClass as! UIAppearanceContainer.Type])
        } else {
            label = UILabel.appearance()
        }
        
        self.applyToLabel(appearanceModel, label: label)
    }
    
    /**
     applyToTextView apply current
     model to label object
     
     - parameters:
     - appearanceModel: model to apply styles.
     - label: UILabel to apply styles.
     */
    
    public func applyToTextView(_ appearanceModel: AppearanceModel, textView: UITextView?) {
        
        /// check if appearanceType is "button"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "textView" {
                return
            }
        }
        
        if let text = textView?.text {
            textView?.attributedText = self.applyStyle(appearanceModel, text: text)
        }
        
        if let backgroundColor = appearanceModel.backgroundColor, let color = appearanceHelpers.convertToUIColor(backgroundColor) {
            textView?.backgroundColor = color
        }
        
        if let tintColor = appearanceModel.tintColor, let color = appearanceHelpers.convertToUIColor(tintColor) {
            textView?.tintColor = color
        }
        
        if let font = appearanceModel.font, let uiFont = appearanceHelpers.convertToUIFont(font) {
            textView?.font = uiFont
        }
        
        if let textColor = appearanceModel.textColor, let color = appearanceHelpers.convertToUIColor(textColor) {
            textView?.textColor = color
        }
        
        self.applyToCALayer(appearanceModel, layer: textView?.layer)
    }
    
    /**
     applyToTextViewAppearance apply current
     model to textView appearance proxy object
     
     - parameters:
     - appearanceModel: model to apply styles.
     */
    
    public func applyToTextViewAppearance(_ appearanceModel: AppearanceModel) {
        
        /// check if appearanceType is "textView"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "textView" {
                return
            }
        }
        
        let textView: UITextView?
        
        if let appearanceWhenContainedIn = appearanceModel.appearanceWhenContainedInClass, let aClass = NSClassFromString(appearanceWhenContainedIn) {
            textView = UITextView.appearance(whenContainedInInstancesOf: [aClass as! UIAppearanceContainer.Type])
        } else {
            textView = UITextView.appearance()
        }
        
        self.applyToTextView(appearanceModel, textView: textView)
    }
    
    /**
     applyToTextField apply current
     model to label object
     
     - parameters:
     - appearanceModel: model to apply styles.
     - label: UILabel to apply styles.
     */
    
    public func applyToTextField(_ appearanceModel: AppearanceModel, textField: UITextField?) {
        
        /// check if appearanceType is "button"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "textField" {
                return
            }
        }
        
        if let text = textField?.text {
            textField?.attributedText = self.applyStyle(appearanceModel, text: text)
        }
        
        if let backgroundColor = appearanceModel.backgroundColor, let color = appearanceHelpers.convertToUIColor(backgroundColor) {
            textField?.backgroundColor = color
        }
        
        if let tintColor = appearanceModel.tintColor, let color = appearanceHelpers.convertToUIColor(tintColor) {
            textField?.tintColor = color
        }
        
        if let font = appearanceModel.font, let uiFont = appearanceHelpers.convertToUIFont(font) {
            textField?.font = uiFont
        }
        
        if let textColor = appearanceModel.textColor, let color = appearanceHelpers.convertToUIColor(textColor) {
            textField?.textColor = color
        }
        
        self.applyToCALayer(appearanceModel, layer: textField?.layer)
    }
    
    /**
     applyToTextFieldAppearance apply current
     model to textField appearance proxy object
     
     - parameters:
     - appearanceModel: model to apply styles.
     */
    
    public func applyToTextFieldAppearance(_ appearanceModel: AppearanceModel) {
        
        /// check if appearanceType is "textField"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "textField" {
                return
            }
        }
        
        let textField: UITextField?
        
        if let appearanceWhenContainedIn = appearanceModel.appearanceWhenContainedInClass, let aClass = NSClassFromString(appearanceWhenContainedIn) {
            textField = UITextField.appearance(whenContainedInInstancesOf: [aClass as! UIAppearanceContainer.Type])
        } else {
            textField = UITextField.appearance()
        }
        
        self.applyToTextField(appearanceModel, textField: textField)
    }
    
    /**
     applyToSegmentedControl apply current
     model to UISegmentedControl object
     
     - parameters:
     - appearanceModel: model to apply styles.
     - label: UILabel to apply styles.
     */
    
    public func applyToSegmentedControl(_ appearanceModel: AppearanceModel, segmentedControl: UISegmentedControl?) {
        
        /// check if appearanceType is "button"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "segmentedControl" {
                return
            }
        }
        
        if let backgroundColor = appearanceModel.backgroundColor, let color = appearanceHelpers.convertToUIColor(backgroundColor) {
            segmentedControl?.backgroundColor = color
        }
        
        if let tintColor = appearanceModel.tintColor, let color = appearanceHelpers.convertToUIColor(tintColor) {
            segmentedControl?.tintColor = color
        }
        
        // both font and textColor required

        if let font = appearanceModel.font, let uiFont = appearanceHelpers.convertToUIFont(font), let textColor = appearanceModel.textColor, let color = appearanceHelpers.convertToUIColor(textColor) {

            segmentedControl?.defaultConfiguration(font: uiFont, color: color)
            
            if let selectedTextColor = appearanceModel.selectedTextColor, let color2 = appearanceHelpers.convertToUIColor(selectedTextColor) {
                segmentedControl?.selectedConfiguration(font: uiFont, color: color2)
            }
        }
        
        if let removeDividers = appearanceModel.removeDividers, removeDividers == true {
            segmentedControl?.removeDividers()
            segmentedControl?.removeBorders()
        }
        
        segmentedControl?.layer.masksToBounds = true
        
        self.applyToCALayer(appearanceModel, layer: segmentedControl?.layer)
    }
    
    /**
     applyToSegmentedControlAppearance apply current
     model to segmentedControl appearance proxy object
     
     - parameters:
     - appearanceModel: model to apply styles.
     */
    
    public func applyToSegmentedControlAppearance(_ appearanceModel: AppearanceModel) {
        
        /// check if appearanceType is "segmentedControl"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "segmentedControl" {
                return
            }
        }
        
        let segmentedControl: UISegmentedControl?
        
        if let appearanceWhenContainedIn = appearanceModel.appearanceWhenContainedInClass, let aClass = NSClassFromString(appearanceWhenContainedIn) {
            segmentedControl = UISegmentedControl.appearance(whenContainedInInstancesOf: [aClass as! UIAppearanceContainer.Type])
        } else {
            segmentedControl = UISegmentedControl.appearance()
        }
        
        self.applyToSegmentedControl(appearanceModel, segmentedControl: segmentedControl)
    }
    
    /**
     applyToButton apply current
     model to button object
     
     - parameters:
     - appearanceModel: model to apply styles.
     - button: UIButton to apply styles.
     */
    
    public func applyToButton(_ appearanceModel: AppearanceModel, button: UIButton?) {
        
        /// check if appearanceType is "button"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "button" {
                return
            }
        }
        
        if let label = button?.titleLabel, let text = label.text {
            label.attributedText = self.applyStyle(appearanceModel, text: text)
        }
        
        if let contentEdgeInsets = appearanceModel.contentEdgeInsets, let edgeInsets = appearanceHelpers.convertToUIEdgeInsets(contentEdgeInsets) {
            button?.contentEdgeInsets = edgeInsets
        }
        
        if let titleColor = appearanceModel.titleColor, let color = appearanceHelpers.convertToUIColor(titleColor) {
            button?.setTitleColor(color, for: appearanceHelpers.buttonControlState(appearanceModel.titleColorState))
        }
        
        if let buttonBackgroundImage = appearanceModel.backgroundImage {
            button?.setBackgroundImage(UIImage(contentsOfFile: buttonBackgroundImage), for: appearanceHelpers.buttonControlState(appearanceModel.backgroundImageState))
        }
        
        if let backgroundColor = appearanceModel.backgroundColor, let color = appearanceHelpers.convertToUIColor(backgroundColor) {
            button?.backgroundColor = color
        }
        
        if let tintColor = appearanceModel.tintColor, let color = appearanceHelpers.convertToUIColor(tintColor) {
            button?.tintColor = color
        }
        
        if let font = appearanceModel.font, let uiFont = appearanceHelpers.convertToUIFont(font) {
            button?.titleLabel?.font = uiFont
        }
        
        if let sizeToFitWidth = appearanceModel.sizeToFitWidth, sizeToFitWidth == true {
            button?.sizeToFitWidth()
        }
        
        self.applyToCALayer(appearanceModel, layer: button?.layer)
    }
    
    /**
     applyToButtonAppearance apply current
     model to button appearance proxy object
     
     - parameters:
     - appearanceModel: model to apply styles.
     */
    
    public func applyToButtonAppearance(_ appearanceModel: AppearanceModel) {
        
        /// check if appearanceType is "button"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "button" {
                return
            }
        }
        
        let button: UIButton?
        
        if let appearanceWhenContainedIn = appearanceModel.appearanceWhenContainedInClass, let aClass = NSClassFromString(appearanceWhenContainedIn) {
            button = UIButton.appearance(whenContainedInInstancesOf: [aClass as! UIAppearanceContainer.Type])
        } else {
            button = UIButton.appearance()
        }
        
        self.applyToButton(appearanceModel, button: button)
    }
    
    /**
     applyToSwitch apply current
     model to UISwitch object
     
     - parameters:
     - appearanceModel: model to apply styles.
     - switchUI: UISwitch to apply styles.
     */
    
    public func applyToSwitch(_ appearanceModel: AppearanceModel, switchUI: UISwitch?) {
        
        /// check if appearanceType is "button"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "switch" {
                return
            }
        }
        
        if let backgroundColor = appearanceModel.backgroundColor, let color = appearanceHelpers.convertToUIColor(backgroundColor) {
            switchUI?.backgroundColor = color
        }
        
        if let tintColor = appearanceModel.tintColor, let color = appearanceHelpers.convertToUIColor(tintColor) {
            switchUI?.tintColor = color
        }
        
        self.applyToCALayer(appearanceModel, layer: switchUI?.layer)
    }
    
    /**
     applyToSwitchAppearance apply current
     model to switch appearance proxy object
     
     - parameters:
     - appearanceModel: model to apply styles.
     */
    
    public func applyToSwitchAppearance(_ appearanceModel: AppearanceModel) {
        
        /// check if appearanceType is "switch"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "switch" {
                return
            }
        }
        
        let switchUI: UISwitch?
        
        if let appearanceWhenContainedIn = appearanceModel.appearanceWhenContainedInClass, let aClass = NSClassFromString(appearanceWhenContainedIn) {
            switchUI = UISwitch.appearance(whenContainedInInstancesOf: [aClass as! UIAppearanceContainer.Type])
        } else {
            switchUI = UISwitch.appearance()
        }
        
        self.applyToSwitch(appearanceModel, switchUI: switchUI)
    }
    
    /**
     applyToImageView apply current
     model to UIImageView object
     
     - parameters:
     - appearanceModel: model to apply styles.
     - imageView: UIImageView to apply styles.
     */
    
    public func applyToImageView(_ appearanceModel: AppearanceModel, imageView: UIImageView?) {
        
        /// check if appearanceType is "button"
        if let styleType = appearanceModel.appearanceType {
            if styleType != "imageView" {
                return
            }
        }
        
        if let backgroundColor = appearanceModel.backgroundColor, let color = appearanceHelpers.convertToUIColor(backgroundColor) {
            imageView?.backgroundColor = color
        }
        
        if let tintColor = appearanceModel.tintColor, let color = appearanceHelpers.convertToUIColor(tintColor) {
            imageView?.tintColor = color
        }
        
        self.applyToCALayer(appearanceModel, layer: imageView?.layer)
    }
    
    /**
     applyToCALayer apply current UI object
     
     - parameters:
     - appearanceModel: model to apply styles.
     - layer: CALayer to apply styles.
     */
    
    public func applyToCALayer(_ appearanceModel: AppearanceModel, layer: CALayer?) {
        
        if let borderColor = appearanceModel.borderColor, let color = appearanceHelpers.convertToUIColor(borderColor)?.cgColor {
            layer?.borderColor = color
        }
        
        if let borderWidth = appearanceModel.borderWidth, let width = Float(borderWidth) {
            layer?.borderWidth = CGFloat(width)
        }
        
        if let cornerRadius = appearanceModel.cornerRadius, let radius = Float(cornerRadius) {
            layer?.cornerRadius = CGFloat(radius)
        }
        
        if let shadowColor = appearanceModel.shadowColor, let color = appearanceHelpers.convertToUIColor(shadowColor)?.cgColor {
            layer?.shadowColor = color
        }
        
        if let shadowRadius = appearanceModel.shadowRadius, let radius = Float(shadowRadius) {
            layer?.cornerRadius = CGFloat(radius)
        }
    }
    
    /**
     applyStyle apply attributed style current UI object
     
     - parameters:
     - appearanceModel: model to apply styles.
     - text: text to return as AtributedText
     - return: NSAttributedString
     */
    
    public func applyStyle(_ appearanceModel: AppearanceModel, text: String) -> NSAttributedString {
        
        let attrString = NSMutableAttributedString(string: text)
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = appearanceHelpers.lineBreakMode(appearanceModel.styleLinebreak)
        
        if let alignmentText = appearanceModel.styleAlignment {
            style.alignment = appearanceHelpers.textAlignment(alignmentText)
        }
        
        if let lineSpacing = Float(appearanceModel.styleLineSpacing ?? "") {
            style.lineSpacing = CGFloat(lineSpacing)
        }
        
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:style, range:NSMakeRange(0, attrString.length))
        
        return attrString
    }
}
