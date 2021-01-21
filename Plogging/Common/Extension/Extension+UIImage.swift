//
//  Extension+UIImage.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/07.
//

import UIKit

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
