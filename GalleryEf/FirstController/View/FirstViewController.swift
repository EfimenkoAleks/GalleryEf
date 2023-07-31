//
//  FirstViewController.swift
//  GalleryEf
//
//  Created by user on 27.07.2023.
//

import UIKit
import AVFoundation

class FirstViewController: BaseViewController, UINavigationControllerDelegate  {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var takeVideo: UIButton!
    @IBOutlet private weak var takePhoto: UIButton!
    
    lazy var viewModel: FirstViewModelProtocol = {
        let viewModel = FirstViewModel()
        return viewModel
    }()
    private var imageTake: UIImageView?
    private var videoView: UIView?
    private var videoPlayer: CustomPlayer?
    private var imagePicker: ImagePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Take image
    
    @IBAction private func didTabTakePhoto(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showPickerWithSourceType(type: viewModel.selectImageFrom(.photoLibrary))
            return
        }
        showPickerWithSourceType(type: viewModel.selectImageFrom(.photo))
    }
    
    //MARK: - Take video
    
    @IBAction private func didTabTakeVideo(_ sender: UIButton) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            showPickerWithSourceType(type: viewModel.selectImageFrom(.video))
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [unowned self] (granted: Bool) in
                DispatchQueue.main.async {
                    if granted {
                        self.showPickerWithSourceType(type: self.viewModel.selectImageFrom(.video))
                    } else {
                        self.showAlert(AppManager.shared.strManager.noAccessToCamera,
                                       message: AppManager.shared.strManager.permissionsToCamera)
                    }
                }
            })
        }
    }
}

private extension FirstViewController {
    func playVideo(_ theVideoURL: URL?) {
        guard let videoURL = theVideoURL else {
            showAlert(AppManager.shared.strManager.error,
                      message: AppManager.shared.strManager.videoNotFound)
            return
        }
        rejectContainer()
        videoView = UIView()
        videoView?.frame = containerView.bounds
        guard let videoView = videoView else { return }
        containerView.addSubview(videoView)
        videoPlayer = CustomPlayer(playerView: videoView, videoUrl: videoURL)
    }
    
    func setImage(_ image: UIImage) {
        rejectContainer()
        imageTake = UIImageView()
        imageTake?.frame = containerView.bounds
        guard let imageTake = imageTake else { return }
        containerView.addSubview(imageTake)
        imageTake.image = image
    }
    
    func rejectContainer() {
        imageTake?.removeFromSuperview()
        imageTake = nil
        videoView?.removeFromSuperview()
        videoView = nil
    }
    
    func showPickerWithSourceType(type: PickerModel) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker = ImagePicker(presentationController: self, delegate: self, type: type)
        }
        else {
            showAlert(AppManager.shared.strManager.error,
                      message: AppManager.shared.strManager.devicesOnly)
        }
    }
    
    //MARK: - Saving Image here
    
    func saveImageToLibrary(_ image: UIImage?) {
        guard let selectedImage = image else {
            showAlert(AppManager.shared.strManager.error,
                      message: AppManager.shared.strManager.imageNotFound)
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        setImage(selectedImage)
    }
    
    func saveVideoToLibrary(_ theVideoURL: URL?) {
        guard let theVideoURL = theVideoURL else {
            showAlert(AppManager.shared.strManager.error,
                      message: AppManager.shared.strManager.videoNotFound)
            return
        }
        UISaveVideoAtPathToSavedPhotosAlbum((theVideoURL.path), self, #selector(FirstViewController.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
        
        playVideo(theVideoURL)
    }
    
    //MARK: - Add to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(AppManager.shared.strManager.saveError,
                      message: error.localizedDescription)
        } else {
            showAlert(AppManager.shared.strManager.saved,
                      message: AppManager.shared.strManager.imageSaved)
        }
    }
    
    @objc func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        if let error = error {
            showAlert(AppManager.shared.strManager.saveError,
                      message: error.localizedDescription)
        }else{
            showAlert(AppManager.shared.strManager.saved,
                      message: AppManager.shared.strManager.videoSaved)
        }
    }
}

// MARK: - ImagePickerDelegate

extension FirstViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        saveImageToLibrary(image)
    }
    
    func didSelect(videoUrl: URL?) {
        guard let videoUrl = videoUrl else { return }
        saveVideoToLibrary(videoUrl)
    }
}
