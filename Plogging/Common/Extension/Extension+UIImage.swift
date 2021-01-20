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
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { context in
            view.layer.render(in: context.cgContext)
        }
        UIGraphicsEndImageContext()
        guard let rederingImage = image.cgImage else {
            return nil
        }
        self.init(cgImage: rederingImage)
    }
    
   
    
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
