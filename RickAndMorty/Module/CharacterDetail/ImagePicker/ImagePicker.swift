//
//  ImagePicker.swift
//  RickAndMorty
//
//  Created by Pavel Kostin on 02.10.2024.
//

import UIKit
import PhotosUI

protocol ImagePickerDelegate: AnyObject {
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage)
    func cancellButtonDidClick(on imagePicker: ImagePicker)
}

final class ImagePicker: NSObject {
    
    enum SwitchAlert {
        case camera
        case photo
    }
    
    var countCancellTapCamera = 0
    var countCancellTapPhoto = 0
    
    private weak var pickerController: UIImagePickerController?
    private weak var pHPController: PHPickerViewController?
    weak var delegate: ImagePickerDelegate?
    
   func dismissPicker() {
        pickerController?.dismiss(animated: true)
    }
    
   func dismissPHPicker() {
        pHPController?.dismiss(animated: true)
    }
    
    // MARK: - Present PHPickerVC
    func presentPHPicker(from viewController: UIViewController) {
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let pHPickerController = PHPickerViewController(configuration: configuration)
        pHPickerController.delegate = self
        self.pHPController = pHPickerController
        
        DispatchQueue.main.async {
            viewController.present(pHPickerController, animated: true)
        }
    }
    
    // MARK: - Present PickerVC
    func presentPickerVC(from viewController: UIViewController, sourceType: UIImagePickerController.SourceType, allowsEditing: Bool = false) {
        
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = allowsEditing
        self.pickerController = imagePickerController
        
        DispatchQueue.main.async {
            viewController.present(imagePickerController, animated: true)
        }
    }
    
    
    func showImagePicker(from viewController: UIViewController, allowsEditing: Bool) {
     
        
        // MARK: - Camera
        let optionMenu = UIAlertController(title: nil, message: Constants.titleAlertLoad, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(title: Constants.titleAlertCamera, style: .default) { [unowned self] _ in
                AVCaptureDevice.requestAccess(for: .video) { camera in
                    DispatchQueue.main.async {
                        if camera {
                            self.presentPickerVC(from: viewController, sourceType: .camera, allowsEditing: allowsEditing)
                            
                        } else {
                            optionMenu.dismiss(animated: true) {
                                self.customAlert(on: viewController, count: self.countCancellTapCamera, type: .camera)
                            }
                        }
                    }
                }
            }
            optionMenu.addAction(takePhotoAction)
        }
        
        // MARK: - Gallery
        let takeGalleryImage = UIAlertAction(title: Constants.titleAlertGallery, style: .default) { [unowned self] _ in
            checkPhotoLibraryPermission { success in
                DispatchQueue.main.async {
                    if success {
                        self.presentPHPicker(from: viewController)
                    } else {
                        optionMenu.dismiss(animated: true) {
                            self.customAlert(on: viewController, count: self.countCancellTapPhoto, type: .photo)
                        }
                    }
                }
            }
        }
        
        optionMenu.addAction(takeGalleryImage)
        
        let cancelAction = UIAlertAction(title: Constants.titleAlertCancel, style: .cancel)
        optionMenu.addAction(cancelAction)
        
        viewController.present(optionMenu, animated: true)
    }
    
    //MARK: - Check Photo status
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            completion(true)
        case . denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    // MARK: - Custom alert for camera and photo library
    func customAlert(on viewController: UIViewController, count: Int, type: SwitchAlert) {
        var countCancell = count
        
        let alertAccess = UIAlertController(title: type == .camera ? Constants.titleAccessCamera : Constants.titleAccessPhoto,
                                            message: type == .camera ? Constants.titleDescriptionAccessCamera : Constants.titleDescriptionAccessPhoto,
                                            preferredStyle: .alert)
        
        let settingAction = UIAlertAction(title: Constants.titleAlertAccess,
                                          style: .default,
                                          handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:])
            }
        })
        
        let cancelAction = UIAlertAction(title: Constants.titleAlertPhotoAndCameraCancel, style: .cancel) { _ in
            countCancell += 1
            if countCancell > 1 {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:])
                }
            }
        }
        
        alertAccess.addAction(settingAction)
        alertAccess.addAction(cancelAction)
        
        viewController.present(alertAccess, animated: true)
    }
}

// MARK: - extension ImagePicker
extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            delegate?.imagePicker(self, didSelect: originalImage)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.cancellButtonDidClick(on: self)
        
        picker.dismiss(animated: true)
    }
}

// MARK: - extension PHPicker
extension ImagePicker: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let itemprovider = results.first?.itemProvider {
            if itemprovider.canLoadObject(ofClass: UIImage.self) {
                itemprovider.loadObject(ofClass: UIImage.self) { image, error in
                    if let selectedImage = image as? UIImage {
                        self.delegate?.imagePicker(self, didSelect: selectedImage)
                    }
                }
            }
        }
    }
}
