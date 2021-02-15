//
//  BaseURL.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/11.
//

import Foundation

struct BaseURL {
    static let mainURL = "https://nexters.plogging.kro.kr:20000"
}

struct BasePath {
    // USER
    static let user = "/user"
    static let userSocial = "/user/social"
    static let userCheck = "/user/check"
    static let userSignIn = "/user/sign-in"
    static let userSignOut = "/user/sign-out"
    static let userPassword = "/user/password"
    static let userPasswordTemp = "/user/password-temp"
    
    // PLOGGING
    static let plogging = "/plogging"
    static let ploggingScore = "/plogging/score"
    
    //TODO : userId 필요
    static let ploggingResult = "/plogging/jsu3417@naver.com:custom"

    // RANKING
    static let rankingGlobal = "/rank/global"
    static let rankUserId = "/rank/users"
}

struct BaseHeader {
    static let userSessionKey = "userId"
}
