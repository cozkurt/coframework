//
//  UIBehaviourFactory.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 01/06/20.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

public struct UIBehaviourItemsParams {
    var allowsRotation: Bool
    var density: CGFloat
    var elasticity: CGFloat
    var friction: CGFloat
    var resistance: CGFloat
    var angularResistance: CGFloat
}

public struct UIBehaviourAttachmentParams {
    var frequency: CGFloat
    var damping: CGFloat
    var length: CGFloat
    var anchorPoint: CGPoint
    var attachedToTag: Int
    var attachedFromTag: Int
}

public struct UIBehaviourPushParams {
    var angle: CGFloat
    var magnitude: CGFloat
    var pushDirection: CGPoint
    var mode: UIPushBehavior.Mode
}

public struct UIBehaviourGravityParams {
    var angle: CGFloat
    var magnitude: CGFloat
    var gravityDirection: CGPoint
}

public struct UIBehaviourSnapParams {
    var damping: CGFloat
    var snapToPoint: CGPoint
}

public enum UIBehaviourType: String {
    case Dynamic
    case Attachment
    case Push
    case Snap
    case Collision
    case Gravity
    case RadialGravityField
    case VortexField
}

public struct UIBehaviourFieldParams {
    var region: CGFloat
    var strength: CGFloat
    var falloff: CGFloat
    var minimumRadius: CGFloat
}

public struct UIBehaviourVortexFieldParams {
    var region: CGFloat
    var strength: CGFloat
    var position: CGPoint
}

open class UIBehaviourFactory {
    
    /// dynamic behaviours. Can be more then one
    var dynamicAnimator: [String:UIDynamicAnimator] = [:]
    
    /// store all behaviours to remove later
    var behaviours: [String:UIDynamicBehavior] = [:]
    
    //
    // MARK: - sharedInstance for singleton access
    //
    public static let sharedInstance: UIBehaviourFactory = UIBehaviourFactory()
    
    // MARK: - Init Methods
    
    public init() {}
    
    open func reset() {
        self.removeAllBehaviors()
        self.dynamicAnimator.removeAll()
        self.behaviours.removeAll()
    }
    
    func createDynamicAnimator(_ referenceView: UIView, key: String) {
        guard let _ = self.dynamicAnimator[key] else {
            let animator = UIDynamicAnimator(referenceView: referenceView)
            //animator.setValue(true, forKey: "debugEnabled")
            
            self.dynamicAnimator[key] = animator
            return
        }
    }
    
    func updateItemState(_ parentView: UIView?, view: UIView) {
        guard let parentView = parentView else { return }
        let key = "\(parentView.tag)"
        self.dynamicAnimator[key]?.updateItem(usingCurrentState: view)
    }
    
    func dynamicItemBehavior(_ parentView: UIView?, views: [UIView], params: UIBehaviourItemsParams) {
        guard let parentView = parentView else { return }
        
        let key = "\(parentView.tag)"
        self.createDynamicAnimator(parentView, key: key)
        
        let behaviour = UIDynamicItemBehavior(items: views)
        behaviour.allowsRotation = params.allowsRotation
        behaviour.density = params.density
        behaviour.elasticity = params.elasticity
        behaviour.friction = params.friction
        behaviour.resistance = params.resistance
        behaviour.angularResistance = params.angularResistance
        
        // remove previous behaviours
        for view in views {
            self.removeBehaviour(parentView, view: view, behaviourType: UIBehaviourType.Dynamic)
        }
        
        self.dynamicAnimator[key]?.addBehavior(behaviour)
        
        for view in views {
            let behaviourKey = "\(UIBehaviourType.Dynamic.rawValue)_\(view.tag)"
            self.behaviours[behaviourKey] = behaviour
        }
    }
    
    func attachmentBehavior(_ parentView: UIView?, params: UIBehaviourAttachmentParams) {
        guard let parentView = parentView else { return }
        
        let key = "\(parentView.tag)"
        self.createDynamicAnimator(parentView, key: key)
        
        guard let attachedTo = parentView.viewWithTag(params.attachedToTag),
            let attachedFrom = parentView.viewWithTag(params.attachedFromTag) else {
            return
        }
        
        let behaviour = UIAttachmentBehavior(item: attachedFrom, attachedTo: attachedTo)
        behaviour.frequency = params.frequency
        behaviour.damping = params.damping
        behaviour.length = params.length
        behaviour.anchorPoint = params.anchorPoint
        
        // remove previous behaviours
        self.removeBehaviour(parentView, view: attachedFrom, behaviourType: UIBehaviourType.Attachment)

        self.dynamicAnimator[key]?.addBehavior(behaviour)

        let behaviourKey = "\(UIBehaviourType.Attachment.rawValue)_\(attachedFrom.tag)"
        self.behaviours[behaviourKey] = behaviour
    }
    
    func pushBehavior(_ parentView: UIView?, views: [UIView], params: UIBehaviourPushParams) {
        guard let parentView = parentView else { return }
        
        let key = "\(parentView.tag)"
        self.createDynamicAnimator(parentView, key: key)
        
        let behaviour = UIPushBehavior(items: views, mode: params.mode)
        behaviour.angle = params.angle
        behaviour.magnitude = params.magnitude
        behaviour.pushDirection = CGVector(dx: params.pushDirection.x, dy: params.pushDirection.y)

        // remove previous behaviours
        for view in views {
            self.removeBehaviour(parentView, view: view, behaviourType: UIBehaviourType.Push)
        }

        self.dynamicAnimator[key]?.addBehavior(behaviour)
        
        for view in views {
            let behaviourKey = "\(UIBehaviourType.Push.rawValue)_\(view.tag)"
            self.behaviours[behaviourKey] = behaviour
        }
    }
    
    func snapBehavior(_ parentView: UIView?, view: UIView, params: UIBehaviourSnapParams) {
        guard let parentView = parentView else { return }
        
        let key = "\(parentView.tag)"
        let behaviourKey = "\(UIBehaviourType.Snap.rawValue)_\(view.tag)"
        
        self.createDynamicAnimator(parentView, key: key)
        
        let behaviour = UISnapBehavior(item: view, snapTo: params.snapToPoint)
        behaviour.damping = params.damping

        // remove previous behaviours
        self.removeBehaviour(parentView, view: view, behaviourType: UIBehaviourType.Snap)
        
        self.dynamicAnimator[key]?.addBehavior(behaviour)
        self.behaviours[behaviourKey] = behaviour
    }
    
    func collisionBehavior(_ parentView: UIView?, views: [UIView], barrierViews: [UIView], delegate: UICollisionBehaviorDelegate?) {
        guard let parentView = parentView else { return }
        
        let key = "\(parentView.tag)"
        self.createDynamicAnimator(parentView, key: key)
        
        let behaviour = UICollisionBehavior(items: views)
        behaviour.collisionDelegate = delegate
        behaviour.collisionMode = UICollisionBehavior.Mode.everything
        behaviour.translatesReferenceBoundsIntoBoundary = false
        
        for barrierView in barrierViews {
            
            let fromPoint = barrierView.frame.origin
            let toPoint = CGPoint(x: barrierView.frame.origin.x + barrierView.frame.size.width, y: barrierView.frame.origin.y + barrierView.frame.size.height);
            
            behaviour.addBoundary(withIdentifier: "barrier \(barrierView.tag)" as NSCopying, from: fromPoint, to: toPoint)
        }
        
        // remove previous behaviours
        for view in views {
            self.removeBehaviour(parentView, view: view, behaviourType: UIBehaviourType.Collision)
        }
        
        self.dynamicAnimator[key]?.addBehavior(behaviour)

        for view in views {
            let behaviourKey = "\(UIBehaviourType.Collision.rawValue)_\(view.tag)"
            self.behaviours[behaviourKey] = behaviour
        }
    }
    
    func gravityBehavior(_ parentView: UIView?, views: [UIView], params: UIBehaviourGravityParams) {
        guard let parentView = parentView else { return }
        
        let key = "\(parentView.tag)"
        self.createDynamicAnimator(parentView, key: key)
        
        let behaviour = UIGravityBehavior(items: views)
        behaviour.angle = params.angle
        behaviour.magnitude = params.magnitude
        behaviour.gravityDirection = CGVector(dx: params.gravityDirection.x, dy: params.gravityDirection.y)
        
        // remove previous behaviours
        for view in views {
            self.removeBehaviour(parentView, view: view, behaviourType: UIBehaviourType.Gravity)
        }
        
        self.dynamicAnimator[key]?.addBehavior(behaviour)

        for view in views {
            let behaviourKey = "\(UIBehaviourType.Gravity.rawValue)_\(view.tag)"
            self.behaviours[behaviourKey] = behaviour
        }
    }
    
    func radialGravityFieldBehavior(_ parentView: UIView?, centerView: UIView, orbitingViews: [UIView], params: UIBehaviourFieldParams) {
        guard let parentView = parentView else { return }
        
        let key = "\(parentView.tag)"
        let behaviourKey = "\(UIBehaviourType.RadialGravityField.rawValue)_\(centerView.tag)"
        
        self.createDynamicAnimator(parentView, key: key)
        
        let behaviour = UIFieldBehavior.radialGravityField(position: centerView.center)
        behaviour.region = UIRegion(radius:params.region)
        behaviour.strength = params.strength
        behaviour.falloff = params.falloff
        behaviour.minimumRadius = params.minimumRadius
        
        // add each orbiting view to field
        for view in orbitingViews {
            behaviour.addItem(view)
        }
        
        // remove previous behaviours
        self.removeBehaviour(parentView, view: centerView, behaviourType: UIBehaviourType.RadialGravityField)
        
        self.dynamicAnimator[key]?.addBehavior(behaviour)
        self.behaviours[behaviourKey] = behaviour
    }
    
    func vortexFieldBehavior(_ parentView: UIView?, centerView: UIView, orbitingViews: [UIView], params: UIBehaviourVortexFieldParams) {
        guard let parentView = parentView else { return }
        
        let key = "\(parentView.tag)"
        let behaviourKey = "\(UIBehaviourType.VortexField.rawValue)_\(centerView.tag)"
        
        self.createDynamicAnimator(parentView, key: key)
        
        let behaviour = UIFieldBehavior.vortexField()
        behaviour.position = params.position
        behaviour.region = UIRegion(radius:params.region)
        behaviour.strength = params.strength
        
        // add each orbiting view to field
        for view in orbitingViews {
            behaviour.addItem(view)
        }
        
        // remove previous behaviours
        self.removeBehaviour(parentView, view: centerView, behaviourType: UIBehaviourType.VortexField)
        
        self.dynamicAnimator[key]?.addBehavior(behaviour)
        self.behaviours[behaviourKey] = behaviour
    }
    
    func removeBehaviour(_ parentView: UIView?, view:UIView, behaviourType: UIBehaviourType) {
        guard let parentView = parentView else { return }
        
        let key = "\(parentView.tag)"
        let behaviourKey = "\(behaviourType.rawValue)_\(view.tag)"
        
        if let behaviour = self.behaviours[behaviourKey] {
            self.dynamicAnimator[key]?.removeBehavior(behaviour)
            self.behaviours.removeValue(forKey: behaviourKey)
        }
    }
    
    func removeAllBehaviors() {
        for key in self.dynamicAnimator.keys {
            self.dynamicAnimator[key]?.removeAllBehaviors()
        }
    }
}


