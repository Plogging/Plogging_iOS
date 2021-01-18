//
//  PloggingResultPhotoViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/06.
//

import UIKit

class PloggingResultPhotoViewController: UIViewController {
    let snsUploadImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    var baseImage: UIImage?
    
    func setUpSnsUploadImageViewLayout() {
        snsUploadImageView.translatesAutoresizingMaskIntoConstraints = false
        snsUploadImageView.widthAnchor.constraint(equalToConstant: DeviceScreen.screenWidth).isActive = true
        snsUploadImageView.heightAnchor.constraint(equalToConstant: DeviceScreen.screenWidth).isActive = true
        snsUploadImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        snsUploadImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(snsUploadImageView)
        setUpSnsUploadImageViewLayout()
        let resizedBaseImage = baseImage?.resize(targetSize: CGSize(width: DeviceScreen.screenWidth, height: DeviceScreen.screenWidth))
        
        // 추후 카메라로 찍은 이미지 가져오고, 없으면 기본 이미지 사용으로 변경 + 플로깅 데이터 가져오기
        let ploggingResultImageMaker = PloggingResultImageMaker()
        let ploggingResultImage = ploggingResultImageMaker.createResultImage(resizedBaseImage!, 2.13, "13:30")
        snsUploadImageView.image = ploggingResultImage
    }
}
