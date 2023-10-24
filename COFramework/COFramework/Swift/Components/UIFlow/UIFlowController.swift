//
//  UIFlowController.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit
import ObjectMapper
import Foundation

public protocol UIFlowProtocol {
    
    /// view controller to handle passes userInfo object
    func userInfoHandler(_ userInfo: [AnyHashable: Any]?)
}

public class UIFlowController {
    
    /// Navigation Controller
    var navigationController: UINavigationController?
    
    /// Parent view to be added subView
    var parentView: UIView?
    
    /// instanceName of current Flow Controller
    var instanceName: String = ""
    
    /// Models in array
    var flowModels = [UIFlowModel]()
    
    // MARK: - Init Methods
    
    public init() {}
    
    public init(parentView: UIView, fileName:String?, instanceName: String?, startEventName: String?) {
        
        // assign parent view
        self.parentView = parentView
        self.instanceName = instanceName ?? ""
        
        // load event file
        self.loadFlowModels(fileName)
        
        // register events
        self.registerEvents()
        
        // start event if initially defined
        if let startEventName = startEventName {
            self.startEvent(startEventName, userInfo: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        Logger.sharedInstance.LogDebug("\(instanceName): deinit() called")
    }
    
    // MARK: - Public Methods
    
    /**
     setupNavigationController created new UINavigationController
     and loads initial Storyboard or View Controller
     
     - parameters:
     - rootViewController: initial root view controller
     - hideNavBar: flag to hide nav bar
     */
    
    fileprivate func setupNavigationController(_ rootViewController: UIViewController, flowModel: UIFlowModel?) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        guard let parentView = self.parentView else {
            Logger.sharedInstance.LogWarning("parentView is missing")
            return navigationController
        }
        
        navigationController.isNavigationBarHidden = !(flowModel?.navigationBar ?? false)
        
        navigationController.view.frame = parentView.bounds
        navigationController.view.bounds = parentView.bounds
        
        parentView.addSubview(navigationController.view)
        
        return navigationController
    }
    
    /**
     loadFlowModels load predefined modals and applies to
     flowModels array.
     
     - parameters:
     - fileName: json array for Flow events.
     */
    
    fileprivate func loadFlowModels(_ fileName: String?) {
        
        guard let fileName = fileName else {
            Logger.sharedInstance.LogError("\(instanceName): fileName is missing")
            return
        }

        if let jsonString = try? FileLoader.loadFile(fileName: fileName) {
            
            let mappable = Mapper<UIFlowModel>()
            
            if let flowModels = mappable.mapArray(JSONString: jsonString) {
                self.flowModels = flowModels
            }
            
            Logger.sharedInstance.LogDebug("\(instanceName): File: \(fileName) loaded")
        } else {
            Logger.sharedInstance.LogError("\(instanceName): File: \(fileName) NOT loaded")
        }
    }
    
    /**
     logEvent to print out event
     from flowModels array.
     
     - parameters:
     - model: flowModel
     */
    
    func logEvent(model: UIFlowModel) {
        if let eventName = model.eventName, let navigationType = model.navigationType {
            Logger.sharedInstance.LogDebug(" \(instanceName) Navigating : \(eventName), navigationType : \(navigationType)")
        }
    }
    
    /**
     registerEvents to register all events
     from flowModels array.
     
     - parameters:
     - fileName: json array for Flow events.
     */
    
    fileprivate func registerEvents() {
        
        for flowModel in self.flowModels {
            
            if let eventName = flowModel.eventName {
                NotificationCenter.default.addObserver(self, selector: #selector(self.handleEvent), name: NSNotification.Name(rawValue: eventName), object: nil)
            } else {
                Logger.sharedInstance.LogDebug("\(instanceName) FlowModel missing eventName")
            }
        }
    }
    
    /**
     handle registered events
     
     - parameters:
     - notification: NSNotification
     */
    
    @objc fileprivate dynamic func handleEvent(_ notification: Foundation.Notification) {
        
        // process only flowInstanceName UIFlowController
        // flowInstanceName adde from MenuViewController.flowInstanceName in
        // NotificationsCenterManager post method for every event automaticly
        
        if let flowInstanceName = notification.userInfo?["flowInstanceName"] as? String, flowInstanceName != self.instanceName {
            return
        }
        
        self.startEvent(notification.name.rawValue, userInfo: notification.userInfo)
    }
    
    /**
     startEvent starts event
     
     - parameters:
     - eventName: to get properties to navigate
     - return
     */
    
    fileprivate func startEvent(_ name: String?, userInfo: [AnyHashable: Any]?) {
        
        var viewController: UIViewController?
        
        guard let eventName = name, let flowModel = self.flowModel(forEventName: eventName) else {
            Logger.sharedInstance.LogDebug(" \(instanceName) Handling Event: \(name ?? "") model can't found for event : \(name ?? "")")
            return
        }
        
        if let instanceName = flowModel.instanceName, instanceName != self.instanceName {
            Logger.sharedInstance.LogDebug(" \(instanceName) Handling Event: \(name ?? "") not for this instance : \(self.instanceName ?? "")")
            return
        }
        
        // This will check if event is mapped to another event
        // If it is then it will call that event
        
        if let eventMapTo = flowModel.eventMapTo {
            self.startEvent(eventMapTo, userInfo: userInfo)
            
            Logger.sharedInstance.LogDebug(" \(eventName) mapped to : \(eventMapTo)")
            return
        }
        
        // check if user supplied viewController in userInfo
        if let userInfo = userInfo, let vc = userInfo["viewController"] as! UIViewController? {
            viewController = vc
        } else {
            // This section will check if storyboard
            // or viewController needs to be loaded
            
            if let _ = flowModel.storyBoard {
                viewController = self.loadStoryBoard(flowModel)
            } else {
                viewController = self.loadViewController(flowModel)
            }
        }
        
        // Perform userInfo method if UIFlowProtocol conformed for view controller
        self.userInfoHandler(viewController, userInfo: userInfo)
        
        // for debugging
        self.logEvent(model: flowModel)
        
        // Navigate to view controller
        if let navigationType = flowModel.navigationType {
            switch navigationType {
            case .push:
                self.pushViewController(viewController, flowModel: flowModel)
                break
            case .present:
                self.presentViewController(viewController, flowModel: flowModel)
                break
            case .presentNC:
                self.presentNCViewController(viewController, flowModel: flowModel)
                break
            case .replace:
                self.replaceViewController(viewController, flowModel: flowModel)
                break
            case .pop:
                self.popViewController(flowModel)
                break
            case .popTo:
                self.popToViewController(viewController, flowModel: flowModel)
                break
            case .popToRoot:
                self.popToRootViewController(flowModel)
                break
            case .dismiss:
                self.dismiss(viewController, flowModel: flowModel, fromRoot: false, isSubView: false, userInfo: userInfo)
                break
            case .dismissNC:
                self.dismissNC(flowModel, userInfo: userInfo)
                break
            case .presentSubViewToRoot:
                self.presentSubView(viewController, flowModel: flowModel, toRoot: true, userInfo: userInfo)
                break
            case .dismissSubViewFromRoot:
                self.dismiss(viewController, flowModel: flowModel, fromRoot: true, isSubView: true, userInfo: userInfo)
                break
            case .presentSubView:
                self.presentSubView(viewController, flowModel: flowModel, toRoot: false, userInfo: userInfo)
                break
            case .dismissSubView:
                self.dismiss(viewController, flowModel: flowModel, fromRoot: false, isSubView: true, userInfo: userInfo)
                break
            case .dismissAll:
                self.dismissAll(flowModel: flowModel)
                break
            case .removeAll:
                self.removeAllViewControllers(self.topNavigationController())
                break
            }
        } else {
            self.pushViewController(viewController, flowModel: flowModel)
        }
    }
    
    /**
     checkViewControllerExists
     This method will be checking if vc is already in nc when pushing or presenting
     
     - parameters:
     - viewController: viewController which conforms UIFlowProtocol
     - return
     */
    
    fileprivate func checkViewControllerExists(_ viewController: UIViewController?, flowModel: UIFlowModel?, isRoot:Bool = false) -> Bool {
        
        let navigationController: UINavigationController?
        
        if isRoot {
            navigationController = self.navigationController
        } else {
            navigationController = self.topNavigationController()
        }
        
        // check if viewController already
        // in navigation stack
        
        if let nc = navigationController {
            for vc in nc.viewControllers {
                if vc.nibName == viewController?.nibName {
                    
                    // check to override loading same VC
                    guard let multiple = flowModel?.multiple else {
                        return true
                    }
                    
                    Logger.sharedInstance.LogDebug(" \(vc.nibName ?? "") already in Navigation stack...")
                    
                    return !multiple
                }
            }
        }
        
        return false
    }
    
    /**
     userInfoHandler
     This method will be queried and if conformed than userInfo object will be passed
     
     - parameters:
     - viewController: viewController which conforms UIFlowProtocol
     - userInfo: userInfo object to handle in reviever vc
     - return
     */
    
    fileprivate func userInfoHandler(_ viewController: UIViewController?, userInfo: [AnyHashable: Any]?) {
        
        // check viewController defined
        // otherwise get last viewcontroller from navigation controller
        // last stack
        
        if let currentVC = viewController as? UIFlowProtocol, let userInfo = userInfo {
            currentVC.userInfoHandler(userInfo)
        } else if let nc = self.navigationController, let currentVC = nc.viewControllers.last as? UIFlowProtocol, let userInfo = userInfo {
            currentVC.userInfoHandler(userInfo)
        }
    }
    
    /**
     presentSubView storyboard/view controller
     
     - parameters:
     - viewController: viewController to navigate
     - flowModel: flowModel to get properties to navigate
     - return
     */
    
    fileprivate func presentSubView(_ viewController: UIViewController?, flowModel: UIFlowModel, toRoot: Bool, userInfo: [AnyHashable: Any]?) {
        
        // check if vc is already exists
        if checkViewControllerExists(viewController, flowModel: flowModel, isRoot: true) {
            return
        }
        
        let navigationController: UINavigationController?
        
        if toRoot {
            navigationController = self.navigationController
        } else {
            navigationController = self.topNavigationController()
        }
        
        // Note: maybe check where nc.presentedViewController == nil if root nc
        guard let viewController = viewController, let nc = navigationController, let parentViewController = nc.viewControllers.last else { return }
        
        // check view already added to view
        if flowModel.multiple != true {
            if nc.visibleViewController?.nibName == viewController.nibName { return }
        }
        
        // copy nc frame to view
        viewController.view.frame = nc.view.frame
        
        // notify delegate programaticlly
        parentViewController.viewWillDisappear(true)
        viewController.viewWillAppear(true)
        
        // add to NC
        nc.addChild(viewController)
        nc.view.addSubview(viewController.view)
        
        // assign parent view controller
        viewController.didMove(toParent: parentViewController)
        
        // update status bar and send userIfo to parent vc
        self.updateParentViewController(userInfo: userInfo)
        
        // present animation
        self.addAnimation(viewController, flowModel: flowModel, completion: { (_) in
            // notify delegate programatically
            viewController.viewDidAppear(true)
            parentViewController.viewDidDisappear(true)
        })
    }
    
    /**
     dismiss storyboard/view controller, it also determines if view is subview or view contoller
     and dismissed accordingly
     
     - parameters:
     - viewController: viewController to navigate
     - flowModel: flowModel to get properties to navigate
     - return
     */
    
    fileprivate func dismiss(_ viewController: UIViewController?, flowModel: UIFlowModel, fromRoot: Bool, isSubView: Bool, userInfo: [AnyHashable: Any]?) {
        
        // convert to var
        var flowModel = flowModel
        
        let navigationController: UINavigationController?
        
        if fromRoot {
            navigationController = self.navigationController
        } else {
            navigationController = self.topNavigationController()
        }
        
        guard let nc = navigationController else { return }
        
        // get last viewcontroller as parentviewcontroller
        
        var parentViewController:UIViewController?
        
        if nc.viewControllers.count > 1 {
            parentViewController = nc.viewControllers[nc.viewControllers.count - 2]
        } else {
            parentViewController = nc.viewControllers.last ?? nil
        }
        
        // 1. Search the viewControllers stack first
        
        for vc in nc.viewControllers {
            if vc.nibName == viewController?.nibName {
                
                // we need parent VC's transitionType to dismiss
                // with same animation when presented
                
                if let nibName = self.extractNibName(vc.nibName), flowModel.transitionType == nil {
                    if let fm = self.flowModel(forNibName: nibName) {
                        flowModel = fm
                    }
                }
                
                if flowModel.navigationType?.rawValue == "presentSubView" || isSubView {
                    self.addAnimation(vc, flowModel: flowModel, duration: 0.3, reverse: true) { (_) in
                        
                        parentViewController?.viewWillAppear(true)
                        vc.viewWillDisappear(true)
                        vc.willMove(toParent: nil)
                        
                        vc.view.removeFromSuperview()
                        vc.removeFromParent()
                        
                        vc.viewDidDisappear(true)
                        parentViewController?.viewDidAppear(true)
                        
                        // update status bar and send userIfo to parent vc
                        self.updateParentViewController(userInfo: userInfo)
                    }
                } else {
                    self.dismissViewController(flowModel, userInfo: userInfo)
                }

                Logger.sharedInstance.LogDebug(" \(instanceName) Navigating : \(String(describing: flowModel.eventName)), navigationType : \(String(describing: flowModel.navigationType))")
                
                return
            }
        }
        
        // If our view controller is defined by our UI Flow model, we don't dismiss the last view controller
        if let _ = viewController {
            return
        }
        
        // 2. Otherwise remove last one
        
        guard let lastVC = nc.visibleViewController else { return }
        
        // we need parent VC's transitionType to dismiss
        // with same animation when presented
        
        if let nibName = self.extractNibName(lastVC.nibName), flowModel.transitionType == nil {
            if let fm = self.flowModel(forNibName: nibName) {
                flowModel = fm
            }
        }
        
        if flowModel.navigationType?.rawValue == "presentSubView" || isSubView {
            // animate to dismiss
            self.addAnimation(lastVC, flowModel: flowModel, duration: 0.3, reverse: true) { (_) in
                parentViewController?.viewWillAppear(true)
                lastVC.viewWillDisappear(true)
                
                lastVC.willMove(toParent: nil)
                lastVC.view.removeFromSuperview()
                lastVC.removeFromParent()
                
                lastVC.viewDidDisappear(true)
                parentViewController?.viewDidAppear(true)
                
                // update status bar and send userIfo to parent vc
                self.updateParentViewController(userInfo: userInfo)
            }
        } else {
            self.dismissViewController(flowModel, userInfo: userInfo)
        }
    }
    
    /**
     updateParentViewController staturBar and send userinfo to parent VC
     
     - parameters:
     - userInfo: userInfo object send to parent
     - return
     */
    
    fileprivate func updateParentViewController(userInfo: [AnyHashable: Any]?) {
        
        guard let nc = self.navigationController, let lastVC = nc.visibleViewController else {
            return
        }
        
        if let nibName = self.extractNibName(lastVC.nibName) {
            if let _ = self.flowModel(forNibName: nibName) {
                self.userInfoHandler(lastVC, userInfo: userInfo)
            }
        }
    }
    
    /**
     nibName extract helper method any _x, _35, _x4 etc.
     
     - parameters:
     - viewController: viewController to navigate
     - flowModel: flowModel to get properties to navigate
     - return
     */
    
    fileprivate func extractNibName(_ nibName: String?) -> String? {
        if let first = nibName?.components(separatedBy: "_").first {
            return first
        } else {
            return nibName
        }
    }
    
    /**
     replaceViewController storyboard/view controller
     
     - parameters:
     - viewController: viewController to navigate
     - flowModel: flowModel to get properties to navigate
     - return
     */
    
    fileprivate func replaceViewController(_ viewController: UIViewController?, flowModel: UIFlowModel) {
        
        // check if vc initialized
        guard let viewController = viewController else { return }
        
        // add transition
        self.addTransition(self.navigationController?.view, flowModel: flowModel, duration: 0.3)
        
        if let navigationController = self.topNavigationController() {
            self.removeAllViewControllers(navigationController)
        } else {
            self.navigationController = self.setupNavigationController(viewController, flowModel: flowModel)
        }
    }
    
    /**
     removeAllViewControllers remove all controllers
     - return
     */
    
    func removeAllViewControllers(_ navigationController: UINavigationController?) {
        
        guard let navigationController = navigationController else {
            return
        }
        
        // remove all viewControllers
        for vc in navigationController.viewControllers {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        
        navigationController.viewControllers.removeAll()
        navigationController.viewControllers = []
    }
    
    /**
     pushViewController storyboard/view controller
     
     - parameters:
     - viewController: viewController to navigate
     - flowModel: flowModel to get properties to navigate
     - return
     */
    
    fileprivate func pushViewController(_ viewController: UIViewController?, flowModel: UIFlowModel) {
        
        // check if vc is already exists
        if checkViewControllerExists(viewController, flowModel: flowModel) {
            return
        }
        
        // check if vc initialized
        guard let viewController = viewController else { return }
        
        if let navigationController = self.topNavigationController() {
            navigationController.pushViewController(viewController, animated: flowModel.animated ?? true)
        } else {
            self.navigationController = self.setupNavigationController(viewController, flowModel: flowModel)
        }
    }
    
    /**
     presentViewController storyboard/view controller
     
     - parameters:
     - viewController: viewController to navigate
     - flowModel: flowModel to get properties to navigate
     - return
     */
    
    fileprivate func presentViewController(_ viewController: UIViewController?, flowModel: UIFlowModel) {
        
        // check if vc is already exists
        if checkViewControllerExists(viewController, flowModel: flowModel) {
            return
        }
        
        // check if vc initialized
        guard let viewController = viewController else { return }
        
        // set vc properties if defined
        if let modalPresentationStyle = flowModel.modalPresentationStyle {
            viewController.modalPresentationStyle = modalPresentationStyle
        }
        
        if let modalTransitionStyle = flowModel.modalTransitionStyle {
            viewController.modalTransitionStyle = modalTransitionStyle
        }
        
        if let navigationController = self.topNavigationController() {
            navigationController.present(viewController, animated: flowModel.animated ?? true, completion: nil)
        } else {
            self.navigationController = self.setupNavigationController(viewController, flowModel: flowModel)
        }
    }
    
    /**
     presentNCViewController storyboard/view controller with Navigation Controller
     and make root navigation controller with new one
     
     - parameters:
     - viewController: viewController to navigate
     - flowModel: flowModel to get properties to navigate
     - return
     */
    
    fileprivate func presentNCViewController(_ viewController: UIViewController?, flowModel: UIFlowModel) {
        
        // check if vc is already exists
        if checkViewControllerExists(viewController, flowModel: flowModel) {
            return
        }
        
        // check if vc initialized
        guard let viewController = viewController, let parentView = self.parentView else { return }
        
        if let navigationController = self.topNavigationController() {
            
            let nc = UINavigationController(rootViewController: viewController)
            
            nc.isNavigationBarHidden = !(flowModel.navigationBar ?? false)
            nc.view.frame = parentView.frame
            nc.view.bounds = parentView.bounds
            
            // set vc properties if defined
            if let modalPresentationStyle = flowModel.modalPresentationStyle {
                nc.modalPresentationStyle = modalPresentationStyle
            }
            
            if let modalTransitionStyle = flowModel.modalTransitionStyle {
                nc.modalTransitionStyle = modalTransitionStyle
            }
            
            navigationController.present(nc, animated: flowModel.animated ?? true, completion: nil)
        } else {
            self.navigationController = self.setupNavigationController(viewController, flowModel: flowModel)
        }
    }
    
    /**
     popViewController pop recent view controller
     
     - parameters:
     - viewController: viewController to navigate
     - flowModel: flowModel to get properties to navigate
     - return
     */
    
    fileprivate func popViewController(_ flowModel: UIFlowModel) {
        
        if let navigationController = self.topNavigationController() {
            navigationController.popViewController(animated: flowModel.animated ?? true)
        }
    }
    
    /**
     popToViewController pop recent view controller
     
     - parameters:
     - viewController: viewController to navigate
     - flowModel: flowModel to get properties to navigate
     - return
     */
    
    fileprivate func popToViewController(_ viewController: UIViewController?, flowModel: UIFlowModel) {
        
        // check if vc initialized
        guard let viewController = viewController else { return }
        
        if let navigationController = self.topNavigationController() {
            
            // check if viewcontroller in navigation stack
            
            for vc in navigationController.viewControllers {
                if vc == viewController {
                    navigationController.popToViewController(viewController, animated: flowModel.animated ?? true)
                }
            }
        }
    }
    
    /**
     popToRootViewController pop to root fo navigation controller
     
     - parameters:
     - viewController: viewController to navigate
     - flowModel: flowModel to get properties to navigate
     - return
     */
    
    fileprivate func popToRootViewController(_ flowModel: UIFlowModel) {
        
        if let navigationController = self.topNavigationController() {
            navigationController.popToRootViewController(animated: flowModel.animated ?? true)
        }
    }
    
    /**
     dismissViewController dismiss recent view controller
     
     - parameters:
     - flowModel: flowModel to get properties to navigate
     - return
     */
    
    fileprivate func dismissViewController(_ flowModel: UIFlowModel, userInfo: [AnyHashable: Any]?) {
        
        if let nc = self.navigationController, let lastVC = nc.visibleViewController {
            lastVC.dismiss(animated: flowModel.animated ?? true, completion: {
                self.updateParentViewController(userInfo: userInfo)
            })
        }
    }
    
    /**
     dismissNC dismiss recent navigation controller
     
     - parameters:
     - flowModel: flowModel to get properties to navigate
     - return
     */
    
    fileprivate func dismissNC(_ flowModel: UIFlowModel, userInfo: [AnyHashable: Any]?) {
        
        if let nc = self.topNavigationController(), let lastVC = nc.visibleViewController {
            lastVC.dismiss(animated: flowModel.animated ?? true, completion: {
                nc.dismiss(animated: flowModel.animated ?? true, completion: {
                    self.updateParentViewController(userInfo: userInfo)
                })
            })
        }
    }
    
    /**
     dismissAll dismisses all view controller in root view controller
     
     - parameters:
     - flowModel: flowModel to get properties to navigate
     - return
     */
    
    fileprivate func dismissAll(flowModel: UIFlowModel) {
        
        if let rootVC = self.navigationController?.viewControllers.first {
            rootVC.dismiss(animated: true, completion: nil)
        }
    }
    
    /**
     Find top Navigation Controller if presentNC
     is used
     
     - parameters:
     - return: UINavigationController
     */
    
    fileprivate func topNavigationController() -> UINavigationController? {
        
        guard let navigationController = self.navigationController else {
            return nil
        }
        
        // find if presenting is Navigation Controller
        
        if let presentingNC = navigationController.visibleViewController?.parent as? UINavigationController {
            return presentingNC
        } else {
            return navigationController
        }
    }
    
    /**
     Loads storyboard with identifier
     
     - parameters:
     - storyboardName: storyboard to load
     - identifier: storyBoard Identifier
     - return: UIViewController
     */
    
    fileprivate func loadStoryBoard(_ flowModel: UIFlowModel) -> UIViewController? {
        
        guard let storyBoardName = flowModel.storyBoard, let identifier = flowModel.identifier else {
            Logger.sharedInstance.LogDebug(" \(instanceName) storyBoard/identifier property is missing")
            return nil
        }
        
        let storyboard = UIStoryboard(name: storyBoardName, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        return viewController
    }
    
    /**
     Loads view controller
     
     - parameters:
     - viewControllerName: view controller to load
     - return: UIViewController
     */
    
    fileprivate func loadViewController(_ flowModel: UIFlowModel) -> UIViewController? {
        
        guard let viewControllerName = flowModel.viewController else {
            return nil
        }
        
        return self.loadViewControllerFromNib(viewControllerName)
    }
    
    /**
     loadViewControllerFromNib load view controller
     
     - parameters:
     - viewControllerName: view controller to load
     - return: UIViewController
     */
    
    public func loadViewControllerFromNib(_ viewControllerName: String) -> UIViewController? {
        
        let viewController = self.viewControllerNameSeperate(viewControllerName: viewControllerName).1
        
        if UIDevice().isMac() {
            if let _ = Bundle.main.path(forResource: "\(viewController)_mac", ofType: "nib") {
                return self.viewController(viewControllerName, nibName: "\(viewController)_mac")
            }
        } else if UIDevice().isIPad() {
            if let _ = Bundle.main.path(forResource: "\(viewController)_ipad", ofType: "nib") {
                return self.viewController(viewControllerName, nibName: "\(viewController)_iPadx")
            }
        } else if UIDevice().isIPadx() {
            if let _ = Bundle.main.path(forResource: "\(viewController)_ipadx", ofType: "nib") {
                return self.viewController(viewControllerName, nibName: "\(viewController)_iPadx")
            }
        } else if UIDevice().isScreen35inch() {
            if let _ = Bundle.main.path(forResource: "\(viewController)_35", ofType: "nib") {
                return self.viewController(viewControllerName, nibName: "\(viewController)_35")
            }
        } else if UIDevice().isScreen4inch() {
            if let _ = Bundle.main.path(forResource: "\(viewController)_4", ofType: "nib") {
                return self.viewController(viewControllerName, nibName: "\(viewController)_4")
            } else if let _ = Bundle.main.path(forResource: "\(viewController)_35", ofType: "nib") {
                return self.viewController(viewControllerName, nibName: "\(viewController)_35")
            }
        } else if UIDevice().isScreen47inch() {
            if let _ = Bundle.main.path(forResource: "\(viewController)_47", ofType: "nib") {
                return self.viewController(viewControllerName, nibName: "\(viewController)_47")
            }
        } else if UIDevice().isScreen55inch() {
            if let _ = Bundle.main.path(forResource: "\(viewController)_55", ofType: "nib") {
                return self.viewController(viewControllerName, nibName: "\(viewController)_55")
            }
        } else if UIDevice().isIPhoneX() {
            if let _ = Bundle.main.path(forResource: "\(viewController)_x", ofType: "nib") {
                return self.viewController(viewControllerName, nibName: "\(viewController)_x")
            }
        }
        
        return self.viewController(viewControllerName)
    }
    
    /**
     viewControllerNameSeperate helper method to split Framework name and viewcontroller name
     
     - parameters:
     - viewControllerName: Format Module.ViewControllerName
     - return: UIViewController
     */
    
    public func viewControllerNameSeperate(viewControllerName: String) -> (String, String) {
        let split = viewControllerName.components(separatedBy: ".")
        
        if split.count == 0 {
            return ("", viewControllerName)
        } else {
            return (split.first ?? "", split.last ?? "")
        }
    }
        
    /**
     viewController helper method to load viewController
     with given nibName
     
     - parameters:
     - className: className for viewController
     - nibName: to initialize with nib name
     - return: UIViewController
     */
    
    public func viewController(_ className : String, nibName: String? = nil) -> UIViewController? {
        
        var className = className
        let split = className.components(separatedBy: ".")
        
        //
        // if module name not defined then grab fom class
        //
        
        if split.count == 1 {
            className = NSStringFromClass(UIFlowController.self).components(separatedBy: ".").first! + "." + className
        }
        
        if let aClass = NSClassFromString(className) as? UIViewController.Type {
            if let nibName = nibName {
                return aClass.init(nibName: nibName, bundle: nil)
            } else {
                return aClass.init()
            }
        }
        return nil
    }

    
    /**
     flowModel for given eventName
     
     - parameters:
     - eventName: to get flowModel
     - return: flowModel
     */
    
    fileprivate func flowModel(forEventName eventName:String) -> UIFlowModel? {
        
        for flowModel in self.flowModels {
            if flowModel.eventName == eventName {
                return flowModel
            }
        }
        
        return nil
    }
    
    /**
     flowModel for given nibName
     
     - parameters:
     - nibName: to get flowModel
     - return: flowModel
     */
    
    fileprivate func flowModel(forNibName nibName:String) -> UIFlowModel? {
        
        for flowModel in self.flowModels {
            if flowModel.viewController == nibName {
                return flowModel
            }
        }
        
        return nil
    }
    
    /**
     It adds the animation of navigation flow.
     
     - parameter toView: animation to apply to UIView
     - parameter flowModel: UIFlowModel
     - parameter duration: duration of animation
     */
    
    func addTransition(_ toView: UIView?, flowModel: UIFlowModel, duration: CFTimeInterval = 0.3) {
        
        guard let view = toView else {
            return
        }
        
        let transitionType = (flowModel.transitionType ?? "") == "flip" ? convertFromCATransitionSubtype(CATransitionSubtype.fromLeft) : convertFromCATransitionType(CATransitionType.fade)
        
        let transition = CATransition()
        
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        if transitionType == convertFromCATransitionSubtype(CATransitionSubtype.fromLeft) {
            transition.type = convertToCATransitionType("flip")
            transition.subtype = CATransitionSubtype.fromLeft
        } else {
            transition.type = convertToCATransitionType(transitionType)
        }
        
        view.layer.add(transition, forKey: nil)
    }
    
    /**
     It adds the animation of navigation flow.
     
     - parameter toView: animation to apply to UIView
     - parameter flowModel: UIFlowModel
     - parameter duration: duration of animation
     - parameter reverse: animation reverse
     */
    
    func addAnimation(_ toVC: UIViewController?, flowModel: UIFlowModel, duration: CFTimeInterval = 0.3, reverse: Bool = false, completion: ((Bool) -> Void)? = { (_) in }) {
        
        guard let view = toVC?.view else {
            return
        }
        
        let animationBlock = {
            let transitionType = flowModel.transitionType ?? "present"
            
            if transitionType == "present" {
                
                let fromValue: CGFloat = reverse ? 0 : view.frame.size.height
                let toValue: CGFloat = reverse ? view.frame.size.height : 0
                
                view.frame.origin.y = fromValue
                
                // present animation
                UIView.animate(withDuration: 0.3, animations: {
                    view.frame.origin.y = toValue
                }, completion: completion)
                
            } else if transitionType == "fade" {
                
                let fromValue: CGFloat = reverse ? 1 : 0
                let toValue: CGFloat = reverse ? 0 : 1
                
                view.alpha = fromValue
                
                // present animation
                UIView.animate(withDuration: 0.3, animations: {
                    view.alpha = toValue
                }, completion: completion)
            }
        }
        
        // if DynamicActionSheet then we need to animate back
        // tableView first that fade
        // And do not apply this logic to "DynamicCellViewController" which is for Notifications
        
        if let DynamicActionSheet = toVC as? DynamicActionSheet, reverse {
            DynamicActionSheet.animateDismiss {
                animationBlock()
            }
        } else {
            animationBlock()
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionSubtype(_ input: CATransitionSubtype) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionType(_ input: CATransitionType) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCATransitionType(_ input: String) -> CATransitionType {
    return CATransitionType(rawValue: input)
}
