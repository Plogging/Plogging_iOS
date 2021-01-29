//
//  PloggingResultImageMaker.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/07.
//

import UIKit

class PloggingResultImageMaker {
    func createResultImage(_ baseImage: UIImage, _ distance: String, _ trashCount: String) -> UIImage {
        let ploggingInfoViewCreater = PloggingInfoViewCreater()
        let ploggingInfoView = ploggingInfoViewCreater.createFloggingInfoView(distance, trashCount)
        return ImageRenderingMaker.render(baseImage, ploggingInfoView, CGPoint(x: 0, y: 0))
    }
}
