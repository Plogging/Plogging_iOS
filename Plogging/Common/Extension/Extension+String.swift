//
//  Extension+String.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/20.
//

import UIKit

extension NSMutableAttributedString {
    func newLine(fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: fontSize)]
        self.append(NSMutableAttributedString(string: "\n", attributes: attrs))
        return self
    }
    
    func bold(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: fontSize)]
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }
    
    func normal(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize)]
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailreg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailtesting = NSPredicate(format:"SELF MATCHES %@", emailreg)
        return emailtesting.evaluate(with: self)
    }
    
    func isValidpassword() -> Bool {
        let regs = [("(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&+=]).{8,20}"),
                    ("(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"),
                    ("(?=.*[A-Za-z])(?=.*[!@#$%^&+=]).{8,20}"),
                    ("(?=.*[0-9])(?=.*[!@#$%^&+=]).{8,20}")]
        
        for reg in regs {
            let passwordtesting = NSPredicate(format: "SELF MATCHES %@", reg)
            if passwordtesting.evaluate(with: self) {
                return true
            }
        }
        return false
    }
}
