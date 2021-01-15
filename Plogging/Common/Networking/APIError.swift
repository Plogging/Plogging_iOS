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
    case dataFailed
    
    public var localizedDescription: String {
        switch self {
        case .requestFailed:
            return "요청 실패입니다."
        case .decodingFailed:
            return "디코딩에 실패했습니다."
        case .dataFailed:
            return "데이터 처리 실패입니다."
        }
    }
}
