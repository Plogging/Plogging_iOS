//
//  APIError.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/13.
//

import Foundation

// MARK: APIError
enum APIError: Error {
    case requestFailed
    case decodingFailed
    
    public var localizedDescription: String {
        switch self {
        case .requestFailed:
            return "요청 실패입니다."
        case .decodingFailed:
            return "디코딩에 실패했습니다."
        }
    }
}
