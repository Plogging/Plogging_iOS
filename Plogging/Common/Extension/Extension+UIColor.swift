//
//  Extension+UIColor.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/21.
//

import UIKit

extension UIColor {
    static func getColor(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
    static let black = UIColor.getColor(r: 137, g: 137, b: 137, alpha: 1)
    static let lightGray = UIColor.getColor(r: 182, g: 182, b: 182, alpha: 1)
    static let veryLightPinkTwo = UIColor.getColor(r: 234, g: 234, b: 234, alpha: 1)
    static let tintGreen = UIColor.getColor(r: 55, g: 213, b: 172, alpha: 1)
    static let loginGray = UIColor.getColor(r: 207, g: 216, b: 214, alpha: 1)
    static let onboardingPaleGreen = UIColor.getColor(r: 213, g: 246, b: 233, alpha: 1)
    static let greenBlue = UIColor.getColor(r: 0, g: 184, b: 144, alpha: 1)
    static let rankingGray = UIColor.getColor(r: 206, g: 206, b: 206, alpha: 1)
    static let lightGreenishBlue = UIColor.getColor(r: 114, g: 236, b: 201, alpha: 1)
    static let paleGreyZero = UIColor.getColor(r: 248, g: 250, b: 252, alpha: 0)
    static let strawberry = UIColor.getColor(r: 255, g: 41, b: 67, alpha: 1)
    static let rankingGreen = UIColor.getColor(r: 0, g: 143, b: 122, alpha: 1)
    static let brownGrey = UIColor.getColor(r: 137, g: 137, b: 137, alpha: 1)
}
