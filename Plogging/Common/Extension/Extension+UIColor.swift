//
//  Extension+UIColor.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/21.
//

import UIKit

extension UIColor {
    static let lightGrayColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1)
    static let darkGrayColor = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1)
    static let veryLightPinkTwo = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
    static let tintGreen = UIColor(red: 55/255, green: 213/255, blue: 172/255, alpha: 1)

    static func fromInt(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
