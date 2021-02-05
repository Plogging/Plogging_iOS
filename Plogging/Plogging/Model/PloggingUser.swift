//
//  User.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/18.
//

import Foundation

// MARK: - User
struct PloggingUser: Codable {
    let rc: Int
    let rcmsg: String
    let session: String
    let userImg: String
    let userName: String
}

/// SceneDelegate에서 if User.shared.isFirstTimeUser로 체크하고 OnboardingViewController를 시작점으로 만들어주기
/// 나중에 만들어논 User클래스랑 합치기
/// key는 따로 static으로 만들기
class PloggingUserInfo {
    static let shared = PloggingUserInfo()
    
    func isFirstTimeUser() -> Bool {
        return UserDefaults.standard.bool(forKey: "isFirstTimeUser")
    }
    
    func setIsNotFirstTimeUser() {
        UserDefaults.standard.setValue(true, forKey: "isFirstTimeUser")
    }
}
