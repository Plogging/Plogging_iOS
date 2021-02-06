//
// Created by KHU_TAEWOO on 2021/02/06.
//

import Foundation

enum TrashType: Int {
    case vinyl = 0
    case glass
    case paper
    case plastic
    case can
    case extra

    var type: String {
        switch self {
        case .vinyl:
            return "비닐"
        case .glass:
            return "유리"
        case .paper:
            return "종이"
        case .plastic:
            return "플라스틱"
        case .can:
            return "캔"
        case .extra:
            return "그 외"
        }
    }
}