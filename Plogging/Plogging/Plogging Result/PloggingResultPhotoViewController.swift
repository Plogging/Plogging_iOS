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
    var baseImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(thumbnailImageView)
        setUpThumbnailImageViewLayout()
        let resizedBaseImage = baseImage?.resize(targetSize: CGSize(width: DeviceScreen.screenWidth, height: DeviceScreen.screenWidth))
        
        // 추후 카메라로 찍은 이미지 가져오고, 없으면 기본 이미지 사용으로 변경 + 플로깅 데이터 가져오기
        let ploggingResultImageMaker = PloggingResultImageMaker()
        let ploggingResultImage = ploggingResultImageMaker.createResultImage(resizedBaseImage!, 2.13, "13:30")
        thumbnailImageView.image = ploggingResultImage
    }
    
    private func setUpThumbnailImageViewLayout() {
        thumbnailImageView.widthAnchor.constraint(equalToConstant: DeviceScreen.screenWidth).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: DeviceScreen.screenWidth).isActive = true
        thumbnailImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}
