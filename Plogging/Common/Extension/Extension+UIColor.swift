//
//  Extension+UIColor.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/21.
//

import UIKit

extension UIColor {
    static let black = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1)
    static let lightGray = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1)
    static let darkGray = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1)
    static let veryLightPinkTwo = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
    static let tintGreen = UIColor(red: 55/255, green: 213/255, blue: 172/255, alpha: 1)
    static let loginGray = UIColor(red: 207/255, green: 216/255, blue: 214/255, alpha: 1)
    static let onboardingPaleGreen = UIColor(red: 213/255, green: 246/255, blue: 233/255, alpha: 1)
    static let greenBlue = UIColor(red: 0/255, green: 184/255, blue: 144/255, alpha: 1)
    static let rankingGray = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1)
    static let lightGreenishBlue = UIColor(red: 114/255, green: 236/255, blue: 201/255, alpha: 1)
    static let paleGrey = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1)
    static let paleGreyZero = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 0)
    static let strawberry = UIColor(red: 255/255, green: 41/255, blue: 67/255, alpha: 1)
    static let rankingGreen = UIColor(red: 0/255, green: 143/255, blue: 122/255, alpha: 1)
    static let brownGrey = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1)

    static func fromInt(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
