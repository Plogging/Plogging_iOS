//
//  PloggingResult.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/28.
//

import Foundation

public struct PloggingResult {
    struct Score {
        var exercise: String
        var eco: String
    }
    
    struct Info {
        var time: String
        var distance: String
        var calorie: String
    }
    
    struct TrashInfo {
        var name: String
        var count: String
    }
    
    struct TrashCountSum {
        var sum: String
    }
    
    var score: Score
    var info: Info
    var trashInfos: [TrashInfo]
    var trashCountSum: TrashCountSum
    
}
