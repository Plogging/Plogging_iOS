//
//  Cookie.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/10.
//

import Foundation

class PloggingCookie {
    static let shared = PloggingCookie()
    
    func isFirstTimeUser() -> Bool {
        return getUserCookie() == nil ? true : false
    }
    
    func getUserCookie() -> String? {
        return UserDefaults.standard.string(forKey: "cookie")
    }
    
    func setUserCookie(cookie: String) {
        UserDefaults.standard.setValue(cookie, forKey: "cookie")
    }
}
