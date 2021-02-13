//
//  Cookie.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/10.
//

import Foundation

class PloggingCookie {
    static let shared = PloggingCookie()
    
    let cookie = "cookie"
    
    /// 처음인지 확인하는 함수
    func isFirstTimeUser() -> Bool {
        return getUserCookie() == nil 
    }
    
    /// 유저 쿠키 받기
    func getUserCookie() -> String? {
        return UserDefaults.standard.string(forKey: cookie)
    }
    
    /// 유저 쿠키 저장
    func setUserCookie(cookie: String) {
        UserDefaults.standard.setValue(cookie, forKey: cookie)
    }
    
    /// 유저 쿠키 삭제
    func removeUserCookie() {
        UserDefaults.standard.removeObject(forKey: cookie)
    }
}
