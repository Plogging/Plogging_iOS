//
//  Protocol+LoginValidation.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/31.
//

import Foundation

protocol LoginValidation {
    func checkValidation(email: String, password: String) -> Bool
    func checkWarningValidation(email: String, password: String) -> String?
}

extension LoginValidation {
    func checkValidation(email: String, password: String) -> Bool {
        return email.isValidEmail() && password.isValidpassword()
    }

    func checkWarningValidation(email: String, password: String) -> String? {
        if !email.isValidEmail() {
            return "올바르지 않은 형식의 이메일입니다."
        }
        if !password.isValidpassword() {
            return "대/소문자, 숫자, 특수문자중 2가지 이상의 조합으로 8자이상"
        }
        return nil
    }
    
    func checkPasswordEqual(_ password: String, _ passwordCheck: String) -> Bool {
        return password.elementsEqual(passwordCheck)
    }
}
