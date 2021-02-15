//
//  PloggingResultScore.swift
//  Plogging
//
//  Created by 전소영 on 2021/02/15.
//

import Foundation

struct PloggingResultScore: Codable {
    let rc: Int
    let rcmsg: String
    let score: Score
}

struct Score: Codable {
    let totalScore: Int
    let activityScore: Int
    let environmentScore: Int
}
