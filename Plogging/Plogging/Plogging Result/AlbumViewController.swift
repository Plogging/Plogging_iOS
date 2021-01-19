//
//  AlbumViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/17.
//

import UIKit

class AlbumViewController: UIViewController {
    var baseImage: UIImage?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "renderingAlbumPhoto" {
            guard let PloggingResultPhotoViewController = segue.destination as? PloggingResultPhotoViewController else {
                return
            }
            // 거리, 시간 추가 전달 필요
            PloggingResultPhotoViewController.baseImage = baseImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImagePicker()
    }
    
    private func setUpImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        baseImage = selectedImage
        self.performSegue(withIdentifier: "renderingAlbumPhoto", sender: nil)
    }
}
