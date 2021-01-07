//
//  PloggingResultPhotoViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/06.
//

import UIKit

class PloggingResultPhotoViewController: UIViewController {
    
    @IBOutlet weak var snsUploadImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 추후 카메라로 찍은 이미지 가져오고, 없으면 기본 이미지 사용으로 변경 + 플로깅 데이터 가져오기
        let ploggingResultImageMaker = PloggingResultImageMaker()
        let ploggingResultImage = ploggingResultImageMaker.createResultImage(UIImage(named: "snsBaseImage")!, 2.13, "13:30")
        snsUploadImageView.image = ploggingResultImage
    }
}
