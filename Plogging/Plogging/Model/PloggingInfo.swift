//
//  Plogging.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/13.
//

import Foundation

// MARK: - PloggingInfo
struct PloggingInfo: Codable {
    let rc: Int
    let rcmsg: String
    let plogging_list: [PloggingList]
    
    enum PloggingInfoCodingKeys: String, CodingKey {
        case ploggingList = "plogging_list"
    }
}

// MARK: - PloggingList
struct PloggingList: Codable {
    let id: String?
    let meta: Meta
    let trashList: [Trash]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case meta
        case trashList = "trash_list"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let userId: String?
    let createTime: Int?
    let distance: Int
    let calories: Int
    let ploggingTime: Int
    let ploggingImage: String?
    let ploggingTotalScore: Int?
    let ploggingActivityScore: Int?
    let ploggingEnvironmentScore: Int?
    
    enum MetaCodingKeys: String, CodingKey {
        case userId = "user_id"
        case createTime = "create_time"
        case ploggingTime = "plogging_time"
        case ploggingImage = "plogging_img"
        case ploggingTotalScore = "plogging_total_score"
        case ploggingActivityScore = "plogging_activity_score"
        case ploggingEnvironmentScore = "plogging_environment_score"
    }
}

// MARK: - TrashList
struct Trash: Codable {
    let trashType: Int
    let pickCount: Int
    
    enum TrashCodingKeys: String, CodingKey {
        case trashType = "trash_type"
        case pickCount = "pick_count"
    }
}

struct TrashItem {
    var trashType: TrashType
    var pickCount = 0
}

// MARK: - PloggingResult
struct PloggingResult {
    // 플로깅 거리 (m)
    let distance: Int?
    let calories: Int?
    // 플로깅 시간 (초)
    let ploggingTime: Int?
    var trashList: [TrashItem]?
}

extension Array where Element == Trash {
    func getTrashPickTotalCount() -> Int {
        reduce(0) { $0 + $1.pickCount }
    }
}
