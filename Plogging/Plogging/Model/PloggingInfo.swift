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
    let meta: PagingMeta
    let ploggingList: [PloggingList]
    
    enum PloggingInfoCodingKeys: String, CodingKey {
        case ploggingList = "plogging_list"
    }
}

struct PagingMeta: Codable {
    var startPageNumber: Int
    var endPageNumber: Int
    var currentPageNumber: Int
}

// MARK: - PloggingList
struct PloggingList: Codable {
    let id: String?
    let meta: Meta
    let trashList: [TrashList]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case meta
        case trashList = "trash_list"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let userId: String?
    let createTime: String?
    let distance: Int
    let calorie: Int
    let ploggingTime: Int
    let ploggingImage: String?
    let ploggingTotalScore: Int?
    let ploggingTrashCount: Int?
 
    
    enum MetaCodingKeys: String, CodingKey {
        case userId = "user_id"
        case createTime = "create_time"
        case ploggingTime = "plogging_time"
        case ploggingImage = "plogging_img"
        case ploggingTotalScore = "plogging_total_score"
        case ploggingTrashCount = "plogging_trash_count"
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

extension Array where Element == TrashList {
    func getTrashPickTotalCount() -> Int {
        reduce(0) { $0 + $1.pickCount }
    }
}
