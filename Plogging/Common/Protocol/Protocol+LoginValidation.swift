//
//  Protocol+LoginValidation.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/31.
//

import Foundation

protocol LoginValidation {}

extension LoginValidation {
    func checkEmailVaidation(email: String) -> String? {
        if email.isValidEmail() {
            return nil
        } else {
            return "올바르지 않은 형식의 이메일입니다."
        }
    }
    
    func checkPasswordValidation(password: String) -> String? {
        if password.isValidpassword() {
            return nil
        } else {
            return "대/소문자, 숫자, 특수문자중 2가지 이상의 조합으로 8자이상"
        }
    }
    
    func checkPasswordEqual(_ password: String, _ passwordCheck: String) -> String? {
        if password == passwordCheck {
            return nil
        } else {
            return "입력하신 비밀번호와 일치하지 않습니다."
        }
    }
}
