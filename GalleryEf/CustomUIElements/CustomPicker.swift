//
//  CustomPicker.swift
//  GalleryEf
//
//  Created by user on 28.07.2023.
//

import UIKit
import MobileCoreServices

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
    func didSelect(videoUrl: URL?)
}

open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    init(presentationController: UIViewController, delegate: ImagePickerDelegate, type: PickerModel) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        pickerController.videoQuality = UIImagePickerController.QualityType.typeMedium
        pickerController.delegate = self
        
        setSourceType(type.sourceType)
        setMediaTypes(type.mediaTypes)
        
        self.presentationController?.present(pickerController, animated: true)
    }
    
    private func setMediaTypes(_ mediaTypes: PickerMediaType) {
        switch mediaTypes {
        case .video:
            pickerController.mediaTypes = [kUTTypeMovie as String]
        case .image:
            pickerController.mediaTypes = [kUTTypeImage as String]
        case .library:
            pickerController.mediaTypes = [kUTTypeImage as String]
        }
    }
    
    private func setSourceType(_ sourceType: PickerSourceType) {
        switch sourceType {
        case .camera:
            pickerController.sourceType = UIImagePickerController.SourceType.camera
        case .library:
            pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
    }

    private func pickerController(_ controller: UIImagePickerController, image: UIImage?, videoUrl: URL?) {
        controller.dismiss(animated: true, completion: nil)

        if let image = image {
            self.delegate?.didSelect(image: image)
        }
        if let videoUrl = videoUrl {
            self.delegate?.didSelect(videoUrl: videoUrl)
        }
        
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, image: nil, videoUrl: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] {
            if (mediaType as AnyObject).description == kUTTypeImage as String {
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.pickerController(picker, image: image, videoUrl: nil)
                }
            }
        }
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] {
            if (mediaType as AnyObject).description == kUTTypeMovie as String {
                let theVideoURL: URL? = (info[UIImagePickerController.InfoKey.mediaURL] as? URL)
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum((theVideoURL?.path)!)) {
                    self.pickerController(picker, image: nil, videoUrl: theVideoURL)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}
