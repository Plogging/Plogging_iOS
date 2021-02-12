//
//  RankingUser.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/05.
//

import Foundation

// MARK: - RankingUser
struct RankingUser: Codable {
    let rc: Int
    let rcmsg: String
    let data: UserRankData
}

// MARK: - UserRankData
struct UserRankData: Codable {
    let userId: String
    let displayName: String
    let profileImg: String
    let rank: Int
    let score: String
}
