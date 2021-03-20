//
//  Extension+UIView.swift
//  Plogging
//
//  Created by 김혜리 on 2021/03/20.
//

import UIKit

extension UIView {
    func nothing() {
        self.layer.borderWidth = 0
    }
    
    func valid() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.tintGreen.cgColor
    }
    
    func unvalid() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.strawberry.cgColor
    }
}
