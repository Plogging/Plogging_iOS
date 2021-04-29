//
//  PloggingResultImageMaker.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/07.
//

import UIKit

class PloggingResultImageMaker {
    func createResultImage(baseImage: UIImage, distance: String, trashCount: String) -> UIImage {
        let ploggingInfoViewCreater = PloggingInfoViewCreater()
        let ploggingInfoView = ploggingInfoViewCreater.createPloggingInfoView(distance: distance, trashCount: trashCount)
        return ImageRenderingMaker.render(baseImage, ploggingInfoView, CGPoint(x: 0, y: 0))
    }
}
