//
//  UINib+Load.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/07/19.
//  Copyright © 2019 Cenker Ozkurt, Inc. All rights reserved.
//

import UIKit

extension UINib {

    @objc func loadIntoView(_ view: UIView) {
        guard let content =
            instantiate(withOwner: view, options: nil).first as? UIView else { return }

        content.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(content)

        view.addConstraint(NSLayoutConstraint(item: content, attribute: .top,
            relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: content, attribute: .bottom,
            relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: content, attribute: .left,
            relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: content, attribute: .right,
            relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))

    }
}

internal extension UINib {
    static func loadXIBFromClassBundle<T: UIView>(_ view: T.Type) -> UINib {
        let bundle = Bundle(for: T.self)
        return loadXIB(view, bundle: bundle)
    }

    static func loadXIB<T: UIView>(_ view: T.Type, bundle: Bundle = .main) -> UINib {
        let identifier = NSStringFromClass(T.self).components(separatedBy: ".").last!
        return UINib(nibName: identifier, bundle: bundle)
    }
}
