//
//  ImageViewWithMask.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 11/13/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit

@IBDesignable
class UIImageViewWithMask: UIImageView {
    var maskImageView = UIImageView()

    @IBInspectable
    var maskImage: UIImage? {
        didSet {
            maskImageView.image = maskImage
            updateView()
        }
    }

    // This updates mask size when changing device orientation (portrait/landscape)
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }

    func updateView() {
        if maskImageView.image != nil {
            maskImageView.frame = bounds
            mask = maskImageView
        }
    }
}
