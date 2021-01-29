//
//  Extension+UIButton.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/18.
//

import UIKit

extension UIButton {
    func marginImageWithText(margin: CGFloat) {
        imageEdgeInsets = UIEdgeInsets(top: 0,
                                       left: -margin,
                                       bottom: 0,
                                       right: margin)
    }
}
