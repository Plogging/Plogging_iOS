//
//  RankingGlobal.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/05.
//

import Foundation

// MARK: - RankingGlobal
struct RankingGlobal: Codable {
    let rc: Int
    let rcmsg: String
    let count: Int
    let rankData: [RankingData]
}

// MARK: - RankingData
struct RankingData: Codable {
    let userId: String
    let displayName: String
    let profileImg: String
    let score: String
}
