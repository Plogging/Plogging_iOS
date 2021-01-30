//
// Created by KHU_TAEWOO on 2021/01/29.
//

import Foundation
import UIKit
extension UILabel {
    func addCharacterSpacing(kernValue: Double = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }

    func addLineSpacing(height: CGFloat) {
        guard let targetText = text else { return }
        let styledString = NSMutableAttributedString(string: targetText)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = height
        styledString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, styledString.length))
        attributedText = styledString
    }

}