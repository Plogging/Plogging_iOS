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
    let meta: RankingMeta
    let data: [RankingData]
}

// MARK: - RankingMetas
struct RankingMeta: Codable {
    let startPageNumber: Int
    let endPageNumber: Int
    let currentPageNumber: Int
}

// MARK: - RankingData
struct RankingData: Codable {
    let userId: String
    let displayName: String
    let profileImg: String
    let score: String
}
