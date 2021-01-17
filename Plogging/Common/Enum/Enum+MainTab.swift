//
//  Enum+TabBarItems.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/13.
//

import Foundation

enum MainTab {
    case ranking
    case plogging
    case myPage
    
    var segueIdentifier: String {
        switch self {
        case .ranking:
            return "RankingSegue"
        case .plogging:
            return "PloggingSegue"
        case .myPage:
            return "MypageSegue"
        }
    }
    
    var index: Int {
        switch self {
        case .ranking:
            return 0
        case .plogging:
            return 1
        case .myPage:
            return 2
        }
    }
}
