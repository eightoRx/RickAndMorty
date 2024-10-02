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
        
        let optionMenu = UIAlertController(title: nil, message: "Загрузите изображение", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(title: "Камера", style: .default) { [unowned self] _ in
                self.presentPickerVC(from: viewController, sourceType: .camera, allowsEditing: allowsEditing)
            }
            optionMenu.addAction(takePhotoAction)
        }
        
        let takeGalleryImage = UIAlertAction(title: "Галерея", style: .default) { [unowned self] _ in
            self.presentPHPicker(from: viewController)
        }
        optionMenu.addAction(takeGalleryImage)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        optionMenu.addAction(cancelAction)
        
        viewController.present(optionMenu, animated: true)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            delegate?.imagePicker(self, didSelect: editImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            delegate?.imagePicker(self, didSelect: originalImage)
        } else {
            print("Image source not recognized")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.cancellButtonDidClick(on: self)
    }
}

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

extension PHPhotoLibrary {
    
    static func execute(controller: UIViewController,
                        onAccessHasBeenGranted: @escaping () -> Void,
                        onAccessHasBeenDenied: (() -> Void)? = nil) {
        let onDeniedOrRestricted = onAccessHasBeenDenied ?? {
            let alert = UIAlertController(title: "Нужен доступ",
                                          message: "Необходим доступ",
                                          preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            })
            DispatchQueue.main.async {
                controller.present(alert, animated: true)
            }
        }
        
        
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .notDetermined:
            onNotDetermined(onDeniedOrRestricted, onAccessHasBeenGranted)
        case .denied, .restricted:
            onDeniedOrRestricted()
        case .authorized:
            onAccessHasBeenGranted()
        case .limited:
            break
        @unknown default:
            break
        }
    }
    
    private static func onNotDetermined(_ onDeniedOrRestricted: @escaping (() -> Void),
                                        _ onAuthorized: @escaping (() -> Void)) {
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            switch status {
            case .notDetermined:
                self.onNotDetermined(onDeniedOrRestricted, onAuthorized)
            case .denied, .restricted:
                onDeniedOrRestricted()
            case .authorized:
                onAuthorized()
            case .limited:
                break
            @unknown default:
                fatalError("PHPhotoLibrary::execute - case")
            }
        }
    }
}

