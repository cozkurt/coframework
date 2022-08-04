//
//  MenuViewController.swift
//  Traderonic
//
//  Created by Cenker Ozkurt on 10/8/19.
//  Copyright © 2021 Traderonic. All rights reserved.
//

import UIKit
import COFramework

class MenuViewController: AdvancedPageViewController {
    
    // listen for chaneTab event
    static var changeTabSignal: SignalData<String> = SignalData()
    static var windowsSizeChangedSignal: SignalData<CGFloat> = SignalData()
    
    static var loadMenuItems: Signal = Signal()
    static var updateMenuBadges: Signal = Signal()
    
    @IBOutlet weak var menuItemsView: UIView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var logoImageView: UIImageView?
    
    // macCatalyst screen width
    // this will e updated when first launch or size changes
    // by user
    
    var windowsWidth: CGFloat = 1000.0
    
    var menuItems:[(String,String)] = []
    var badges: [Int] = []
    
    var scrollButtonOnLastValue = true
    
    /// turned off because delete action is effected in the cells
    var isPagingEnabled = false
    
    static var flowInstanceName: String?
    
    var lastSelectedIndex:IndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            MenuViewController.flowInstanceName = self.flowControllersList?[lastSelectedIndex.row].1
        }
    }
    
    var lastSelectedTabName: String {
        return self.flowControllersList?[lastSelectedIndex.row].tabName ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set alpha 0
        self.menuItemsView.alpha = 0
        
        // menu items setup block
        MenuViewController.loadMenuItems.bind(self) { [weak self] in
            self?.setUpMenuItems()
            self?.setupControllers()
            self?.setupBadges()
            self?.setUpOthers()
        }
        
        MenuViewController.updateMenuBadges.bind(self) { [weak self] in
            self?.setUpMenuItems()
            self?.setupBadges()
            
            runOnMainQueue {
                self?.collectionView?.reloadData()
            }
        }
        
        MenuViewController.windowsSizeChangedSignal.bind(self) { [weak self] (width) in
            self?.windowsWidth = min(width ?? 0, 1000)
            self?.viewRotated()
        }
        
        NotificationsCenterManager.sharedInstance.flowInstanceNameCallBack = {
            return (name: "flowInstanceName", value: MenuViewController.flowInstanceName)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        MenuViewController.loadMenuItems.notify()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // update menu items width
        // related to window width
        
        let width = UIApplication.shared.windows[0].frame.size.width
        
        self.windowsWidth = min(width, 1000)
        self.viewRotated()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.lastSelectedIndex = IndexPath(row: 0, section: 0)
    }
    
    @objc func viewRotated() {
        runOnMainQueue(after: 0.1) {
            self.collectionView?.reloadData()
        }
        
        // animate indicator image
        runOnMainQueue(after: 0.2) {
            self.updateIndicatorPosition(indexPath: self.lastSelectedIndex)
        }
    }
    
    func setUpMenuItems() {
        // Setup Menu Items
        #if DEBUG
        self.menuItems = [
            ("DynamicCells".localize(),"list.bullet.indent"),
            ("Styles".localize(),"list.bullet.indent"),
            ("Dynamics".localize(),"list.bullet.indent"),
            ("Animations".localize(),"list.bullet.indent")]
        #else
        self.menuItems = [
            ("DynamicCells".localize(),"list.bullet.indent"),
            ("Styles".localize(),"list.bullet.indent"),
            ("Dynamics".localize(),"list.bullet.indent"),
            ("Animations".localize(),"list.bullet.indent")]
        #endif
    }
    
    func setupControllers() {
        #if DEBUG
        self.pagesWithFlowControllers([("MainFlow", "DynamicCellTab", "DYNAMIC_CELLS_VIEW"),
                                       ("MainFlow", "StylesTab", "STYLES_VIEW"),
                                       ("MainFlow", "DynamicsTab", "DYNAMICS_VIEW"),
                                       ("MainFlow", "AnimationsTab", "ANIMATIONS_VIEW")])
        #else
        self.pagesWithFlowControllers([("MainFlow", "DynamicCellTab", "DYNAMIC_CELLS_VIEW"),
                                       ("MainFlow", "StylesTab", "STYLES_VIEW"),
                                       ("MainFlow", "DynamicsTab", "DYNAMICS_VIEW"),
                                       ("MainFlow", "AnimationsTab", "ANIMATIONS_VIEW")])
        #endif
    }
    
    func setupBadges() {
        let notificationsCount = 0
        
        // Set badge number
        runOnMainQueue {
            UIApplication.shared.applicationIconBadgeNumber = notificationsCount
        }
        
        #if DEBUG
            self.badges = [ notificationsCount,0,0,0 ]
        #else
            self.badges = [ notificationsCount,0,0,0 ]
        #endif
    }
    
    func setUpOthers() {
        
        // animate indicator image
        Timer.after(0.3, {
            self.updateIndicatorPosition(indexPath: self.lastSelectedIndex)
        })
        
        // turn on/off paging by user
        self.pageViewController.isPagingEnabled = self.isPagingEnabled
        
        // slide to page
        self.slideToPage(index: self.lastSelectedIndex.row)
        
        // register tabchnage listener
        self.registerListeners()
        
        // animate back
        UIView.animate(withDuration: 0.3) {
            self.menuItemsView?.alpha = 1
            self.logoImageView?.alpha = 0
        }
    }
    
    func registerListeners() {
        MenuViewController.changeTabSignal.bind(self) { tabName in
            
            runOnMainQueue() {
                self.slideToTab(tabName: tabName)
            }
            
            runOnMainQueue(after: 0.1) {
                self.scrollToIndex(indexPath: self.lastSelectedIndex)
            }
        }
    }
    
    override func pageChanged(_ pageNumber: Int) {
        self.scrollToIndex(indexPath: IndexPath(row: pageNumber, section: 0))
    }
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.backgroundColor = .clear
            collectionView.alwaysBounceVertical = true
            collectionView.isPagingEnabled = false
            
            collectionViewFlowLayout.minimumLineSpacing = 0
            collectionViewFlowLayout.minimumInteritemSpacing = 0
            
            collectionView.register(UINib(nibName: "MenuItemCell", bundle: nil), forCellWithReuseIdentifier: "MenuItemCell")
        }
    }
    
    fileprivate var collectionViewFlowLayout: UICollectionViewFlowLayout {
        return collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
    }
}

// MARK: - MenuTabViewController: UICollectionViewDataSource

extension MenuViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: MenuItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCell", for: indexPath) as? MenuItemCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(menuItem: menuItems[indexPath.row], indexPath: indexPath, menuItemcount: menuItems.count)
        cell.badge(count: self.badges[indexPath.row])
        
        return cell
    }
}

// MARK: - MenuTabViewController: UICollectionViewDelegate

extension MenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // update pageviewController position
        self.slideToPage(index: indexPath.row)
        
        // scroll to selected item
        self.scrollToIndex(indexPath: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // block scrolling horizontally
        if scrollView.contentOffset.y != 0 {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0), animated: false)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateIndicatorPosition(indexPath: lastSelectedIndex)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.updateIndicatorPosition(indexPath: lastSelectedIndex)
    }
    
    @objc func updateIndicatorPosition(indexPath: IndexPath) {
        
        // animate indicator image
        let selectedItem = self.collectionView.cellForItem(at: indexPath)
        
        if let width = selectedItem?.frame.size.width, let origin = selectedItem?.frame.origin {
            Timer.after(0.3, {
                let position = self.collectionView.convert(origin, to: self.view)
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.indicatorView.frame.origin = CGPoint(x: (position.x + width / 2) - self.indicatorView.frame.size.width / 2, y: self.indicatorView.frame.origin.y)
                })
            })
        }
    }
    
    @objc func scrollToIndex(indexPath: IndexPath) {

        // check if item is exists
        if self.collectionView.hasItemAtIndexPath(indexPath: self.lastSelectedIndex) {
            // scroll to selected item
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        // animate indicator image
        self.updateIndicatorPosition(indexPath: indexPath)
        
        // save last index
        self.lastSelectedIndex = indexPath
    }
}

// MARK: - MenuTabViewController: UICollectionViewDelegateFlowLayout

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let menuItemsCount = CGFloat(self.menuItems.count)
        let screenWidth = UIDevice().isMac() ? self.windowsWidth : UIScreen.main.bounds.width
        let width = UIDevice().isIPad() || UIDevice().isMac() ? screenWidth / menuItemsCount : screenWidth / 5

        return CGSize(width: width, height: 80)
    }
}

// MARK: - MenuTabViewController: UIFlowProtocol

extension MenuViewController: UIFlowProtocol {
    func userInfoHandler(_ userInfo: [AnyHashable : Any]?) {
        if let row = userInfo?["menuTabIndex"] as? Int {
            self.lastSelectedIndex.row = row
        }
    }
}
