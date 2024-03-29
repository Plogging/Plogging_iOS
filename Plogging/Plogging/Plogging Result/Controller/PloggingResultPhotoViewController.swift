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
    var ploggingResult: PloggingResult?
    var trashCountSum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(thumbnailImageView)
        setUpThumbnailImageViewLayout()
        guard let resizedBaseImage = baseImage?.resize(targetSize: CGSize(width: DeviceInfo.screenWidth, height: DeviceInfo.screenWidth)) else {
            return
        }
        let ploggingResultImageMaker = PloggingResultImageMaker()
        let ploggingResultImage = ploggingResultImageMaker.createResultImage(baseImage: resizedBaseImage, distance: String(format: "%.2f", Float(ploggingResult?.distance ?? 0)/1000), trashCount: "\(trashCountSum)")
        thumbnailImageView.image = ploggingResultImage
        thumbnailImage = ploggingResultImage
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moveToPloggingResultViewController(_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifier.unwindToPloggingResult, sender: self)
    }
   
    private func setUpThumbnailImageViewLayout() {
        thumbnailImageView.widthAnchor.constraint(equalToConstant: DeviceInfo.screenWidth).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: DeviceInfo.screenWidth).isActive = true
        thumbnailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 107).isActive = true
    }
}
