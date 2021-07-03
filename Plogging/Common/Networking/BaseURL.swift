//
//  BaseURL.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/11.
//

import Foundation

struct BaseURL {
    static let mainURL = "https://eco-run.duckdns.org"
    
    static func getURL(basePath: BasePath) -> String {
        return BaseURL.mainURL + basePath.path
    }
}

enum BasePath {
    // USER
    case user
    case userSocial
    case userApple
    case userCheck
    case userSignIn
    case userSignOut
    case userName
    case userImage
    case userPassword
    case userPasswordTemp
    
    // PLOGGING
    case plogging
    case ploggingResult(String)
    case ploggingScore
    
    // RANKING
    case rankingGlobal
    case rankUserId(String)
    
    var path: String {
        switch self {
        case .user:
            return "/user"
        case .userSocial:
            return "/user/social"
        case .userApple:
            return "/user/apple"
        case .userCheck:
            return "/user/check"
        case .userSignIn:
            return "/user/sign-in"
        case .userSignOut:
            return "/user/sign-out"
        case .userName:
            return "/user/name"
        case .userImage:
            return "/user/image"
        case .userPassword:
            return "/user/password"
        case .userPasswordTemp:
            return "/user/password-temp"
        case .plogging:
            return "/plogging"
        case .ploggingScore:
            return "/plogging/score"
        case .ploggingResult(let id):
            return "/plogging/\(id)"
        case .rankingGlobal:
            return "/rank/global"
        case .rankUserId(let id):
            return "/rank/users/\(id)"
        }
    }
}
