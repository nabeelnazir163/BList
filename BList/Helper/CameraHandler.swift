//
//  CameraHandler.swift
//  Salarix
//
//  Created by iOS TL on 30/06/22.
//

import Foundation
import UIKit


class CameraHandler: NSObject{
    static let shared = CameraHandler()
    
    fileprivate var currentVC: UIViewController!
    
    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var mediaURLPickedBlock: ((URL) -> Void)?
    func camera(galleryType: GalleryType = .onlyPhotos) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            switch galleryType {
            case .onlyPhotos:
                myPickerController.mediaTypes = ["public.image"]
            case .onlyVideos:
                myPickerController.mediaTypes = ["public.movie"]
            case .photos_Videos:
                myPickerController.mediaTypes = ["public.image","public.movie"]
            }
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary(galleryType: GalleryType = .onlyPhotos) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            switch galleryType {
            case .onlyPhotos:
                myPickerController.mediaTypes = ["public.image"]
            case .onlyVideos:
                myPickerController.mediaTypes = ["public.movie"]
            case .photos_Videos:
                myPickerController.mediaTypes = ["public.image","public.movie"]
            }
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    
    func showActionSheet(preference: GalleryType = .onlyPhotos, vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera(galleryType: preference)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary(galleryType: preference)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
}

enum GalleryType {
    case onlyPhotos
    case onlyVideos
    case photos_Videos
}
extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[UIImagePickerController.InfoKey.mediaType] as? String == "public.movie", let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            currentVC.dismiss(animated: true) {[weak self] in
                guard let self = self else{return}
                self.mediaURLPickedBlock?(mediaURL)
            }
        } else if info[UIImagePickerController.InfoKey.mediaType] as? String == "public.image", let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            currentVC.dismiss(animated: true) {[weak self] in
                guard let self = self else{return}
                self.imagePickedBlock?(img)
            }
        }
    }
}
