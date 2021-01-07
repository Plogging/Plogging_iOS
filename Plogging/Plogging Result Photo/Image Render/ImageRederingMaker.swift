//
//  ImageRederingMaker.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/07.
//

import UIKit

class ImageRederingMaker {
    
    static func render(_ baseImage: UIImage, _ targetView: UIView, _ rectPoint: CGPoint) -> UIImage? {
        let baseView = UIImageView.init(image: baseImage)
        targetView.frame = CGRect(x: 0, y: rectPoint.y , width: 0, height: 0)
        baseView.addSubview(targetView)
        guard let rederingImage = UIImage.init(view: baseView) else {
            return nil
        }
        return rederingImage
    }
}
