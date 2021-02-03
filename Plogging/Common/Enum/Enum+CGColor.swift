//
// Created by KHU_TAEWOO on 2021/01/25.
//

import Foundation
import CoreGraphics

extension CGColor {
    static func fromInt(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> CGColor {
        CGColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}