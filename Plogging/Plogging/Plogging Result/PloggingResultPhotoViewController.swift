//
//  PloggingResultPhotoViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/06.
//

import UIKit

class PloggingResultPhotoViewController: UIViewController {
    private let thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var thumbnailImage: UIImage?
    var baseImage: UIImage?
    
    @IBAction func moveToPloggingResultViewController(_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifier.unwindToPloggingResult, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(thumbnailImageView)
        setUpThumbnailImageViewLayout()
        guard let resizedBaseImage = baseImage?.resize(targetSize: CGSize(width: DeviceScreen.width, height: DeviceScreen.width)) else {
            return
        }
        let ploggingResultImageMaker = PloggingResultImageMaker()
        let ploggingResultImage = ploggingResultImageMaker.createResultImage(resizedBaseImage, 2.13, "13:30")
        thumbnailImageView.image = ploggingResultImage
        thumbnailImage = ploggingResultImage
    }
   
    private func setUpThumbnailImageViewLayout() {
        thumbnailImageView.widthAnchor.constraint(equalToConstant: DeviceScreen.width).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: DeviceScreen.width).isActive = true
        thumbnailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
