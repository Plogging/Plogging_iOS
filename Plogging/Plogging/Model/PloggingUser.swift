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
