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
        case rc
        case rcmsg
        case meta
        case ploggingList = "plogging_list"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PloggingInfoCodingKeys.self)
        rc = try values.decode(Int.self, forKey: .rc)
        rcmsg = try values.decode(String.self, forKey: .rcmsg)
        meta = try values.decode(PagingMeta.self, forKey: .meta)
        ploggingList = try values.decode([PloggingList].self, forKey: .ploggingList)
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
    let trashList: [Trash]

    enum PloggingListCodingKeys: String, CodingKey {
        case id = "_id"
        case meta
        case trashList = "trash_list"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PloggingListCodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        meta = try values.decode(Meta.self, forKey: .meta)
        trashList = try values.decode([Trash].self, forKey: .trashList)
    }
}

// MARK: - Meta
struct Meta: Codable {
    let userId: String?
    let createdTime: String?
    let distance: Int
    let calorie: Int
    let ploggingTime: Int
    let ploggingImage: String?
    let ploggingTotalScore: Int?
    let ploggingTrashCount: Int?
 
    enum MetaCodingKeys: String, CodingKey {
        case userId = "user_id"
        case createdTime = "created_time"
        case distance
        case calorie
        case ploggingTime = "plogging_time"
        case ploggingImage = "plogging_img"
        case ploggingTotalScore = "plogging_total_score"
        case ploggingTrashCount = "plogging_trash_count"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MetaCodingKeys.self)
        userId = try values.decode(String.self, forKey: .userId)
        createdTime = try values.decode(String.self, forKey: .createdTime)
        distance = try values.decode(Int.self, forKey: .distance)
        calorie = try values.decode(Int.self, forKey: .calorie)
        ploggingTime = try values.decode(Int.self, forKey: .ploggingTime)
        ploggingImage = try values.decode(String.self, forKey: .ploggingImage)
        ploggingTotalScore = try values.decode(Int.self, forKey: .ploggingTotalScore)
        ploggingTrashCount = try values.decode(Int.self, forKey: .ploggingTrashCount)
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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: TrashCodingKeys.self)
        trashType = try values.decode(Int.self, forKey: .trashType)
        pickCount = try values.decode(Int.self, forKey: .pickCount)
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

extension Array where Element == TrashItem {
    func getTrashPickTotalCount() -> Int {
        reduce(0) { $0 + $1.pickCount }
    }
}
