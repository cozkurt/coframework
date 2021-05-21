//
//  UIBehaviourHelper.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 01/06/20.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

open class UIBehaviourHelper {
    
    var settings: UIBehaviourModel?
    
    //
    // MARK: - sharedInstance for singleton access
    //
    public static let sharedInstance: UIBehaviourHelper = UIBehaviourHelper()
    
    init() {
        self.loadModels("UIBehaviours")
    }
    
    /**
     loadFlowModels load predefined modals and applies to
     flowModels array.
     
     - parameters:
     - fileName: json array for Flow events.
     */
    
    fileprivate func loadModels(_ fileName: String?) {
        
        guard let fileName = fileName else {
            Logger.sharedInstance.LogInfo("fileName is missing")
            return
        }
        
        if let jsonString = try? FileLoader.load(fileName) {
            
            let mappable = Mapper<UIBehaviourModel>()
            
            if let models = mappable.map(JSONString: jsonString) {
                self.settings = models
            }
            
            Logger.sharedInstance.LogInfo("File: \(fileName) loaded")
        } else {
            Logger.sharedInstance.LogError("File: \(fileName) NOT loaded")
        }
    }

    func viewsFromTags(_ parentView: UIView, tags: String) -> [UIView] {
        
        var views: [UIView] = []
        for tagString in tags.components(separatedBy: ",") {
            if let tag = Int(tagString), let view = parentView.viewWithTag(Int(tag)) {
                views.append(view)
            }
        }
        return views
    }
    
    func updateItemState(_ parentView: UIView?, tag: Int) {
        
        guard let parentView = parentView, let view = parentView.viewWithTag(tag) else {
            return
        }
        
        UIBehaviourFactory.sharedInstance.updateItemState(parentView, view: view)
    }
    
    func setupKingNodeDynamics(_ parentView: UIView?, tag: Int) {
        
        guard let parentView = parentView, let view = parentView.viewWithTag(tag), let settings = self.settings, let density = settings.kingDensity else {
            return
        }
        
        let params = UIBehaviourItemsParams(allowsRotation: false, density: CGFloat(density), elasticity: 0, friction: 1, resistance: 1, angularResistance: 0)
        UIBehaviourFactory.sharedInstance.dynamicItemBehavior(parentView, views: [view], params: params)
    }
    
    func setUpNodeDynamics(_ parentView: UIView?, tag: Int) {
        
        guard let parentView = parentView, let view = parentView.viewWithTag(tag), let settings = self.settings, let density = settings.nodeDensity else {
            return
        }
        
        let params = UIBehaviourItemsParams(allowsRotation: false, density: CGFloat(density), elasticity: 1.0, friction: 1, resistance: 1, angularResistance: 0)
        UIBehaviourFactory.sharedInstance.dynamicItemBehavior(parentView, views: [view], params: params)
    }
    
    func setUpCollision(_ parentView: UIView?, barrierViewTags: String, tags: String) {
        guard let parentView = parentView else { return }
        
        UIBehaviourFactory.sharedInstance.collisionBehavior(parentView, views: self.viewsFromTags(parentView, tags: tags), barrierViews: self.viewsFromTags(parentView, tags: barrierViewTags), delegate: nil)
    }
    
    func setUpGravity(_ parentView: UIView?, tags: String) {
        guard let parentView = parentView else { return }
        
        let param = UIBehaviourGravityParams(angle: 0, magnitude: 1, gravityDirection: CGPoint(x: 0, y: 0.5))
        UIBehaviourFactory.sharedInstance.gravityBehavior(parentView, views: self.viewsFromTags(parentView, tags: tags), params: param)
    }
    
    func setUpRadialGravityField(_ parentView: UIView?, centerView: UIView, tags: String, strength: CGFloat) {
        guard let parentView = parentView else { return }
        
        let param = UIBehaviourFieldParams(region: 300, strength: strength, falloff: 1, minimumRadius: 10)
        UIBehaviourFactory.sharedInstance.radialGravityFieldBehavior(parentView, centerView: centerView, orbitingViews: self.viewsFromTags(parentView, tags: tags), params: param)
    }
    
    func setUpVortexField(_ parentView: UIView?, centerView: UIView, tags: String) {
        guard let parentView = parentView else { return }
        
        let param = UIBehaviourVortexFieldParams(region: 200, strength: 1, position: centerView.center)
        UIBehaviourFactory.sharedInstance.vortexFieldBehavior(parentView, centerView: centerView, orbitingViews: self.viewsFromTags(parentView, tags: tags), params: param)
    }
    
    func attachToTag(_ parentView: UIView?, fromTag: Int, toTag: Int, length: Int) {
        guard let parentView = parentView, let settings = self.settings, let damping = settings.attachDamping else { return }
        
        let params = UIBehaviourAttachmentParams(frequency: 1.0, damping: CGFloat(damping), length: CGFloat(length), anchorPoint: CGPoint(x: 0, y: 0), attachedToTag: toTag, attachedFromTag: fromTag)
        UIBehaviourFactory.sharedInstance.attachmentBehavior(parentView, params: params)
    }
    
    func snapToPoint(_ parentView: UIView?, tags: String, point: CGPoint) {
        
        guard let parentView = parentView, let settings = self.settings, let damping = settings.snapDamping else {
            return
        }
        
        for tagString in tags.components(separatedBy: ",") {
            
            guard let tag = Int(tagString), let view = parentView.viewWithTag(Int(tag)) else {
                continue
            }
            
            // remove prevous snap behaviour
            self.removeBehaviour(parentView, tag: tag, behaviourType: UIBehaviourType.Snap)
            
            let params = UIBehaviourSnapParams(damping: CGFloat(damping), snapToPoint: point)
            UIBehaviourFactory.sharedInstance.snapBehavior(parentView, view: view, params: params)
            UIBehaviourFactory.sharedInstance.updateItemState(parentView, view: view)
        }
    }
    
    func randomPush(_ parentView: UIView?, tags: String) {
        guard let parentView = parentView else { return }
        
        for tagString in tags.components(separatedBy: ",") {
            
            guard let tag = Int(tagString), let view = parentView.viewWithTag(Int(tag)) else {
                continue
            }
            
            let params = UIBehaviourPushParams(angle: CGFloat(arc4random_uniform(360)), magnitude: CGFloat(10), pushDirection: CGPoint(x: -10 + CGFloat(arc4random_uniform(10)), y: -10 + CGFloat(arc4random_uniform(10))), mode: .instantaneous)
            
            UIBehaviourFactory.sharedInstance.pushBehavior(parentView, views: [view], params: params)
        }
    }
    
    func removeBehaviour(_ parentView: UIView?, tag: Int, behaviourType: UIBehaviourType) {
        
        guard let parentView = parentView, let view = parentView.viewWithTag(tag) else {
            return
        }
        
        UIBehaviourFactory.sharedInstance.removeBehaviour(parentView, view: view, behaviourType: behaviourType)
    }
    
    func removeAllBehaviours(_ parentView: UIView?, tag: Int) {
        
        guard let parentView = parentView, let view = parentView.viewWithTag(tag) else {
            return
        }
        
        UIBehaviourFactory.sharedInstance.removeBehaviour(parentView, view: view, behaviourType: UIBehaviourType.RadialGravityField)
        UIBehaviourFactory.sharedInstance.removeBehaviour(parentView, view: view, behaviourType: UIBehaviourType.VortexField)
        UIBehaviourFactory.sharedInstance.removeBehaviour(parentView, view: view, behaviourType: UIBehaviourType.Attachment)
        UIBehaviourFactory.sharedInstance.removeBehaviour(parentView, view: view, behaviourType: UIBehaviourType.Collision)
        UIBehaviourFactory.sharedInstance.removeBehaviour(parentView, view: view, behaviourType: UIBehaviourType.Dynamic)
        UIBehaviourFactory.sharedInstance.removeBehaviour(parentView, view: view, behaviourType: UIBehaviourType.Gravity)
        UIBehaviourFactory.sharedInstance.removeBehaviour(parentView, view: view, behaviourType: UIBehaviourType.Push)
        UIBehaviourFactory.sharedInstance.removeBehaviour(parentView, view: view, behaviourType: UIBehaviourType.Snap)
    }
}
