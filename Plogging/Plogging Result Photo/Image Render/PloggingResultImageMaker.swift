//
//  PloggingResultImageMaker.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/07.
//

import UIKit

class PloggingResultImageMaker {
    
    func createResultImage(_ baseImage: UIImage, _ distance: Double, _ time: String) -> UIImage? {
        let ploggingInfoViewCreater = PloggingInfoViewCreater()
        let ploggingInfoView = ploggingInfoViewCreater.createFloggingInfoView(distance, time)
        return ImageRederingMaker.render(baseImage, ploggingInfoView, CGPoint(x: 0, y: baseImage.size.height * 2/3))
    }
}
