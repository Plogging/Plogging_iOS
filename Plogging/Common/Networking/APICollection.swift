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
    
    /// 세션키 발급
    func requestSessionKey() {
        
    }
    
    /// 산책 이력 가져오기
    func getWalkingRecord(param: Parameters, completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.plogging,
                   method: .get,
                   headers: temp
        ).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
                break
            case .failure:
                print("error occured")
                break
            }
        }
    }
    
    /// 산책 이력 등록하기
    func registerWalkingRecord() {
        
    }
    
    /// 산책정보 삭제
    func deleteWalkingRecord() {
        
    }
}
