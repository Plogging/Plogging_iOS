//
//  APICollection.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/11.
//

import Foundation
import Alamofire

struct APICollection {
    static let sharedAPI = APICollection()

    let temp: HTTPHeaders = ["userId": "xowns1234",
                             "Content-Type": "application/json"]

    let login: HTTPHeaders = ["Content-Type": "application/json"]

    /// 로그인 하기
    func requestSessionKey(param: Parameters, completion: @escaping (Result<PloggingUser, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.user,
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: login
        ).responseJSON { response in
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }

            guard let value = try? JSONDecoder().decode(PloggingUser.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
    }
    
    /// 산책 이력 가져오기
    func getWalkingRecord(completion: @escaping (Result<Plogging, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.plogging,
                   method: .get,
                   headers: temp
        ).responseJSON { response in
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }

            guard let value = try? JSONDecoder().decode(Plogging.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
    }
    
    /// 산책 이력 등록하기
    func registerWalkingRecord() {
        
    }
    
    /// 산책정보 삭제
    func deleteWalkingRecord() {
        
    }
}
