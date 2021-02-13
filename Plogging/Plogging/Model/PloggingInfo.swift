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
    let plogging_list: [PloggingList]
    
//    enum PloggingInfoCodingKeys: String, CodingKey {
//        case ploggingList = "plogging_list"
//    }
}

struct PagingMeta: Codable {
    var startPageNumber: Int
    var endPageNumber: Int
    var currentPageNumber: Int
}

// MARK: - PloggingList
struct PloggingList: Codable {
    let _id: String?
    let meta: Meta
    let trash_list: [TrashList]

//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case meta
//        case trashList = "trash_list"
//    }
}

// MARK: - Meta
struct Meta: Codable {
    let user_id: String?
    let created_time: String?
    let distance: Int
    let calorie: Int
    let plogging_time: Int
    let plogging_img: String?
    let plogging_total_score: Int?
    let plogging_trash_count: Int?
 
    
//    enum MetaCodingKeys: String, CodingKey {
//        case userId = "user_id"
//        case createTime = "create_time"
//        case ploggingTime = "plogging_time"
//        case ploggingImage = "plogging_img"
//        case ploggingTotalScore = "plogging_total_score"
//        case ploggingTrashCount = "plogging_trash_count"
//    }
}

// MARK: - TrashList
struct TrashList: Codable {
    let trash_type: Int
    let pick_count: Int
    
//    enum TrashListCodingKeys: String, CodingKey {
//        case trashType = "trash_type"
//        case pickCount = "pick_count"
//    }
}

extension Array where Element == TrashList {
    func getTrashPickTotalCount() -> Int {
        reduce(0) { $0 + $1.pick_count }
    }
}
