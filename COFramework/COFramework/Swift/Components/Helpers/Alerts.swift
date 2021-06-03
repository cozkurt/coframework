//
//  Alerts.swift
//  Lystit
//
//  Created by Cenker Ozkurt on 5/12/20.
//  Copyright © 2020 FuzFuz. All rights reserved.
//

import UIKit

public class Alerts {
    static public func adultContentWarning(_ viewController: UIViewController?) {
        let alert = UIAlertController(title: "Oops".localize(),
                                      message: "Inappropriate content detected".localize(),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK".localize(), style: .default, handler: nil))
        
        viewController?.present(alert, animated: true)
    }
}
