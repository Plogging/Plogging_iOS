//
//  Extension+UIImage.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/07.
//

import UIKit

extension UIImage {
    convenience init?(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let rederingImage = image?.cgImage else {
            return nil
        }
        self.init(cgImage: rederingImage)
    }
}
