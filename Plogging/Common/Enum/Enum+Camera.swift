//
//  Enum+Camera.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/21.
//

import Foundation

enum Camera {
    case back
    case front
    
    var position: String {
        switch self {
        case .back:
            return "back"
        case .front:
            return "front"
        }
    }
}
