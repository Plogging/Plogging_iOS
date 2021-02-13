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
    let trashList: [TrashList]

    enum PloggingListCodingKeys: String, CodingKey {
        case id = "_id"
        case meta
        case trashList = "trash_list"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PloggingListCodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        meta = try values.decode(Meta.self, forKey: .meta)
        trashList = try values.decode([TrashList].self, forKey: .trashList)
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
struct TrashList: Codable {
    let trashType: Int
    let pickCount: Int
    
    enum TrashListCodingKeys: String, CodingKey {
        case trashType = "trash_type"
        case pickCount = "pick_count"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: TrashListCodingKeys.self)
        trashType = try values.decode(Int.self, forKey: .trashType)
        pickCount = try values.decode(Int.self, forKey: .pickCount)
    }
}

extension Array where Element == TrashList {
    func getTrashPickTotalCount() -> Int {
        reduce(0) { $0 + $1.pickCount }
    }
}
