//
//  PloggingUserData.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/16.
//

import Foundation

class PloggingUserData {
    static let shared = PloggingUserData()
    
    var userData: PloggingUserInfo?
    
    let userId = "userId"
    let userName = "userName"
    let userImage = "userImage"
    let apple = "apple"
    
    func saveUserData(id: String, nickName: String, image: String) {
        UserDefaults.standard.setValue(id, forKey: userId)
        UserDefaults.standard.setValue(nickName, forKey: userName)
        UserDefaults.standard.setValue(image, forKey: userImage)
    }
    
    func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: userId)
    }
    
    func setUserName(nickName: String) {
        UserDefaults.standard.setValue(nickName, forKey: userName)
    }
    
    func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: userName)
    }
    
    func getUserImage() -> String? {
        return UserDefaults.standard.string(forKey: userImage)
    }
    
    func setUserImage(userImageUrl: String) {
        UserDefaults.standard.setValue(userImageUrl, forKey: userImage)
    }
    
    func removeUserData() {
        UserDefaults.standard.removeObject(forKey: userId)
        UserDefaults.standard.removeObject(forKey: userName)
        UserDefaults.standard.removeObject(forKey: userImage)
    }
    
    func setUserData(_ userInfo:PloggingUserInfo?) {
        self.userData = userInfo
    }
    
    func getAppleUserIdentifier() -> String? {
        return UserDefaults.standard.string(forKey: apple)
    }
    
    func setAppleUserIdentifier(indentifier: String) {
        UserDefaults.standard.setValue(indentifier, forKey: apple)
    }
}
