//
//  PloggingUserInfo.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/13.
//

import Foundation

// MARK: - PloggingUserInfo
struct PloggingUserInfo: Codable {
    let rc: Int
    let rcmsg: String
    let userId: String
    let userImg: String
    let userName: String
    let scoreMonthly: Int
    let distanceMonthly: Int
    let trashMonthly: Int
    let scoreWeekly: Int
    let distanceWeekly: Int
    let trashWeekly: Int
}
