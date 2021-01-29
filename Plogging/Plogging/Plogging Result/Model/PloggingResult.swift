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
    
    var score: PloggingResult.Score
    var info: PloggingResult.Info
    var trashInfos: [TrashInfo]
}
