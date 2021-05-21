//
//  ImagePicker.swift
//  FuzFuz
//
//  Created by Cenker Ozkurt on 10/22/19.
//  Copyright © 2019 FuzFuz. All rights reserved.
//

import UIKit
import MobileCoreServices

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
    func didSelect(url: URL?)
    func didCancel()
}

open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate
    
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        
        self.pickerController.mediaTypes = ["public.image"]
        
        // uncommennt for video
        // self.pickerController.mediaTypes = ["public.image", "public.movie"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, mode: UIImagePickerController.CameraCaptureMode, title: String) -> UIAlertAction? {
        
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            
            if type == .camera {
                self.pickerController.cameraCaptureMode = mode == .photo ? .photo : .video
                self.pickerController.showsCameraControls = true
            }
            
            self.presentationController?.present(self.pickerController, animated: false)
        }
    }
    
    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIDevice().preferredStyle())
        
        if let action = self.action(for: .camera, mode: .photo, title: "Take photo".localize()) {
            alertController.addAction(action)
        }
        
        // video is not fully implemented yet
//        if let action = self.action(for: .camera, mode: .video, title: "Take video".localize()) {
//            alertController.addAction(action)
//        }

        if let action = self.action(for: .savedPhotosAlbum, mode: .photo, title: "Camera roll".localize()) {
            alertController.addAction(action)
        }
        
        if let action = self.action(for: .photoLibrary, mode: .photo, title: "Photo library".localize()) {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.delegate?.didCancel()
        }))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true) {
            let resizedImage = self.resizeImage(image: image)
            self.delegate?.didSelect(image: resizedImage)
        }
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect url: URL?) {
        controller.dismiss(animated: true) {
            self.delegate?.didSelect(url: url)
        }
    }
    
    private func picketControllerDidCancel(_ controller: UIImagePickerController) {
        controller.dismiss(animated: true) {
            self.delegate?.didCancel()
        }
    }
    
    private func resizeImage(image: UIImage?) -> UIImage? {
        guard let image = image else {
            return nil
        }
                
        var resizedImage = image.resize(to: CGSize(width: 640, height: 480), with: .coreImage) ?? UIImage(systemName: "camera")
        
        // check if it's portrait then rotate
        // automaticlly. otherwise stays as landscape
        
        if image.isPortrait() {
            resizedImage = resizedImage?.imageRotatedByDegrees(deg: 90)
        }
        
        return resizedImage
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picketControllerDidCancel(picker)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
          mediaType == (kUTTypeMovie as String), let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            
            return self.pickerController(picker, didSelect: url)
        }
        
        if let image = info[.originalImage] as? UIImage {
            return self.pickerController(picker, didSelect: image)
        }
    }
}
