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
    let ploggingList: [PloggingList]
    
    enum PloggingInfoCodingKeys: String, CodingKey {
        case ploggingList = "plogging_list"
    }
}

// MARK: - PloggingList
struct PloggingList: Codable {
    let id: String?
    let meta: Meta
    let trashList: [TrashList]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case meta
        case trashList = "pick_list"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let userId: String?
    let createTime: Int?
    let distance: Int
    let calories: Int
    let ploggingTime: Int
    let ploggingImg: String?
    let ploggingTotalScore: Int?
    let ploggingActivityScore: Int?
    let ploggingEnvironmentScore: Int?
    
    enum MetaCodingKeys: String, CodingKey {
        case userId = "user_id"
        case createTime = "create_time"
        case ploggingTime = "plogging_time"
        case ploggingImg = "plogging_img"
        case ploggingTotalScore = "plogging_total_score"
        case ploggingActivityScore = "plogging_activity_score"
        case ploggingEnvironmentScore = "plogging_environment_score"
    }
}

// MARK: - TrashList
struct TrashList: Codable {
    let trashType: Int
    let pickCount: Int
    
    enum TrashListCodingKeys: String, CodingKey {
        case trashType = "trash_type"
        case pickCount = "pick_count"
    }
}
