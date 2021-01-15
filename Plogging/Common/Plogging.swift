//
//  Plogging.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/13.
//

import Foundation

// MARK: - Plogging
struct Plogging: Codable {
    let rc: Int
    let rcmsg: String
    let plogging_list: [PloggingList]
}

// MARK: - PloggingList
struct PloggingList: Codable {
    let id: String
    let meta: Meta
    let trash_list: [TrashList]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case meta
        case trash_list
    }
}

// MARK: - Meta
struct Meta: Codable {
    let user_id: String
    let create_time: Int
    let distance: Int
    let calories: Int
    let plogging_time: Int
    let plogging_img: String
    let plogging_total_score: Int
    let plogging_activity_score: Int
    let plogging_environment_score: Int
}

// MARK: - TrashList
struct TrashList: Codable {
    let trash_type: Int
    let pick_count: Int
}
