//
//  PloggingUserData.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/16.
//

import Foundation

class PloggingUserData {
    static let shared = PloggingUserData()

    /// 아이디 저장
    /// 닉네임 저장
    /// 이미지 저장
    
    let userId = "userId"
    let userName = "userName"
    let userImage = "userImage"
    
    func saveUserData(id: String, nickName: String, image: String) {
        UserDefaults.standard.setValue(id, forKey: userId)
        UserDefaults.standard.setValue(nickName, forKey: userName)
        UserDefaults.standard.setValue(image, forKey: userImage)
    }
    
    func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: userId)
    }
    
    func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: userName)
    }
    
    func getUserImage() -> String? {
        return UserDefaults.standard.string(forKey: userImage)
    }
    
    func removeUserData() {
        UserDefaults.standard.removeObject(forKey: userId)
        UserDefaults.standard.removeObject(forKey: userName)
        UserDefaults.standard.removeObject(forKey: userImage)
    }
}
