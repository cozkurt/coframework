//
//  AdvancedPageViewController.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/7/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit

open class AdvancedPageViewController: UIViewController {

    @IBOutlet public weak var pageView: UIView!
    @IBOutlet public weak var pageControl: UIPageControl!
    
    public var pageViewController: UIPageViewController!
    
    public var imagesList: [UIImage]?
    public var controllersList: [String]?
    public var flowControllersList: [(flowname: String, tabName: String, eventName: String)]?
    
    var currentPageIndex: Int = 0
    
    public var viewControllers: [UIViewController] = []
    public var flowControllers: [UIFlowController] = []
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Public Methods
    
    public func setUpViewControllers() {
        
        if self.viewControllers.count == 0 {
            return
        }
        
        let viewController = self.viewControllers[0]

        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        self.pageViewController.view.frame = self.pageView.bounds
        self.pageViewController.view.autoresizingMask = self.pageView.autoresizingMask
        self.pageViewController.view.contentMode = self.pageView.contentMode
        
        self.pageViewController.setViewControllers([viewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        self.pageView.subviews.forEach { $0.removeFromSuperview() }
        self.pageView.addSubview(self.pageViewController.view)
        
        self.pageControl?.currentPage = 0
    }
    
    public func pagesWithImages(_ imagesList: [UIImage]?) {
        
        guard let imagesList = imagesList else {
            return
        }
        
        self.viewControllers = []
        self.imagesList = imagesList
        self.pageControl?.numberOfPages = imagesList.count
        self.currentPage(0)
        
        for i in 0...(self.imagesList?.count ?? 0) {
            if let vc = self.controllerForIndex(i) {
                self.viewControllers.append(vc)
            }
        }
        
        self.setUpViewControllers()
    }
    
    public func pagesWithControllers(_ controllersList: [String]?) {
        
        guard let controllersList = controllersList else {
            return
        }
        
        self.viewControllers = []
        self.controllersList = controllersList
        self.pageControl?.numberOfPages = controllersList.count
        self.currentPage(0)
        
        for i in 0...(self.controllersList?.count ?? 0) {
            if let vc = self.controllerForIndex(i) {
                self.viewControllers.append(vc)
            }
        }
        
        self.setUpViewControllers()
    }
    
    // filename, instanceName, startEventName
    
    public func pagesWithFlowControllers(_ flowControllersList: [(String,String,String)]?) {
        
        guard let flowControllersList = flowControllersList else {
            return
        }
        
        self.viewControllers = []
        self.flowControllersList = flowControllersList
        self.pageControl?.numberOfPages = flowControllersList.count
        self.currentPage(0)
        
        for i in 0...(self.flowControllersList?.count ?? 0) {
            if let vc = self.controllerForIndex(i) {
                self.viewControllers.append(vc)
            }
        }
        
        self.setUpViewControllers()
    }

    
    // MARK: - Private Methods
    
    func currentPage(_ pageNumber: Int) {
        self.currentPageIndex = pageNumber
        self.pageControl?.currentPage = pageNumber
        
        self.pageChanged(pageNumber)
    }
    
    open func pageChanged(_ pageNumber: Int) {
        // override to get updated pageNumber
    }
    
    func controllerForIndex(_ index:Int) -> UIViewController? {
        if let _ = self.controllersList {
            return self.viewControllerForIndex(index)
        }
        
        if let _ = self.flowControllersList {
            return self.flowControllerForIndex(index)
        }
        
        if let _ = self.imagesList {
            return self.imagesForIndex(index)
        }
        
        return nil
    }
    
    func viewControllerForIndex(_ index: Int) -> UIViewController? {
        guard let controllersList = self.controllersList, index < controllersList.count else {
            return nil
        }
        
        let controller = UIFlowController().loadViewControllerFromNib(controllersList[index])
        
        controller?.view.frame = self.pageView.bounds
        controller?.view.tag = index
        controller?.view.autoresizingMask = self.pageView.autoresizingMask
        controller?.view.contentMode = self.pageView.contentMode
        
        return controller
    }
    
    func flowControllerForIndex(_ index: Int) -> UIViewController? {
        guard let flowControllersList = self.flowControllersList, index < flowControllersList.count else {
            return nil
        }
        
        let controller = UIViewController()
        
        let fileName = flowControllersList[index].0
        let instanceName = flowControllersList[index].1
        let startEventName = flowControllersList[index].2
        
        let flowController = UIFlowController(parentView: controller.view, fileName: fileName, instanceName: instanceName, startEventName: startEventName)
        self.flowControllers.append(flowController)
        
        controller.view.frame = self.pageView.bounds
        controller.view.tag = index
        controller.view.autoresizingMask = self.pageView.autoresizingMask
        controller.view.contentMode = self.pageView.contentMode
        
        return controller
    }
    
    func imagesForIndex(_ index: Int) -> UIViewController? {
        guard let imagesList = self.imagesList, index < imagesList.count else {
            return nil
        }
        
        let controller = UIViewController()
        controller.view = ResizableImageView(image: imagesList[index])
        controller.view.frame = self.pageView.bounds
        controller.view.tag = index
        controller.view.autoresizingMask = self.pageView.autoresizingMask
        controller.view.contentMode = self.pageView.contentMode
        
        return controller
    }
    
    public func slideToTab(tabName: String?) {
        
        let index = self.flowControllersList?.firstIndex(where: { item -> Bool in
            return item.tabName == tabName
        })
        
        if let index = index {
            slideToPage(index: index)
        }
    }
    
    public func slideToPage(index: Int) {
        var count = 0
        
        if let controllers = controllersList {
            count = controllers.count
        } else if let flowControllersList = flowControllersList {
            count = flowControllersList.count
        } else if let images = imagesList {
            count = images.count
        } else {
            return
        }
        
        if index < count {
            if index > self.currentPageIndex {
                let vc = self.viewControllers[index]
                
                self.pageViewController.setViewControllers([vc], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: { (complete) -> Void in
                    self.currentPage(index)
                })
            } else if index < self.currentPageIndex {
                let vc = self.viewControllers[index]
                
                self.pageViewController.setViewControllers([vc], direction: UIPageViewController.NavigationDirection.reverse, animated: false, completion: { (complete) -> Void in
                    self.currentPage(index)
                })
            }
        }
    }
}


// MARK: - AdvancedPageViewController: UIPageViewControllerDelegate

extension AdvancedPageViewController: UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                                               previousViewControllers: [UIViewController],
                                               transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers, let currentViewController = viewControllers.last, completed else { return }

        let index = currentViewController.view.tag;
        self.currentPage(index)
    }
}


// MARK: - AdvancedPageViewController: UIPageViewControllerDataSource

extension AdvancedPageViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = viewController.view.tag;
        index = index - 1
        
        if (index < 0) { return nil }
        
        return self.viewControllers[index]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = viewController.view.tag;
        index = index + 1
        
        if index >= self.viewControllers.count {
            return nil
        }
        
        return self.viewControllers[index]
    }
}
