//
//  ImageHelper.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/21/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit

struct ImageHelper {
    static func createThumbnail(from image: UIImage, fillingSize size: CGSize) -> UIImage {
        let scale = max(size.width / image.size.width, size.height / image.size.height)
        let width = image.size.width * scale
        let height = image.size.height * scale
        let thumbnailRect = CGRect(
            x: (size.width - width) / 2,
            y: (size.height - height) / 2,
            width: width,
            height: height)
        UIGraphicsBeginImageContext(size)
        image.draw(in: thumbnailRect)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return thumbnail!
    }
    
    static func saveToDisk(image: UIImage, compression: CGFloat = 1.0) -> URL {
        var fileURL = FileManager.default.temporaryDirectory
        let filename = UUID().uuidString
        fileURL.appendPathComponent(filename)
        let data = image.jpegData(compressionQuality: compression)!
        try! data.write(to: fileURL)
        return fileURL
    }
}
