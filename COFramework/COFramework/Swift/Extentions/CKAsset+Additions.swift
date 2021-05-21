//
//  CKAsset+Additions.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/21/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

extension CKAsset {
    convenience init(image: UIImage, size: CGFloat, compression: CGFloat) {
        let image = image.resizeWithScaleAspectFitMode(to: size, resizeFramework: .accelerate) ?? UIImage()

        let fileURL = ImageHelper.saveToDisk(image: image, compression: compression)
        self.init(fileURL: fileURL)
    }
    
    var image: UIImage? {
        guard let fileURL = fileURL, let data = try? Data(contentsOf: fileURL),
            let image = UIImage(data: data) else {
                return nil
        }
        
        return image
    }
}
