//
//  WebViewController.swift
//  Lystit
//
//  Created by Cenker Ozkurt on 7/10/20.
//  Copyright © 2020 FuzFuz. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    
    @IBOutlet var leftButton: UIButton!
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    var link: String?
    var header: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let link = self.link, let url = URL(string: link) else {
            return
        }
        
        self.headerLabel?.text = self.header ?? ""
        self.leftButton?.setTitle("Close".localize(), for: .normal)
        
        // table view top space
        self.webView?.scrollView.contentInset.top = 68
        self.webView?.allowsBackForwardNavigationGestures = true
        
        self.webView?.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.addressLabel?.text = webView.url?.absoluteString
    }
    
    @IBAction func backButtonClicked() {
        guard let webView = self.webView, webView.canGoBack else {
            return
        }
        
        self.webView?.goBack()
    }
    
    @IBAction func forwardButtonClicked() {
        guard let webView = self.webView, webView.canGoForward else {
            return
        }

        self.webView?.goForward()
    }
    
    @IBAction func reloadButtonClicked() {
        self.webView?.reload()
    }
    
    @IBAction func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension WebViewController: UIFlowProtocol {
    
    // MARK: For handling UIFlowProtocol
    
    @objc func userInfoHandler(_ userInfo: [AnyHashable: Any]?) {
        
        if let link = (userInfo?["link"] as? String),
            let header = (userInfo?["header"] as? String) {
            self.link = link
            self.header = header
        }
    }
}
