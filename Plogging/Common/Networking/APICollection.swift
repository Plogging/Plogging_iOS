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

    let temp: HTTPHeaders = ["Content-Type": "application/json"]
}

// MARK: - USER
extension APICollection {
    /// 로그인 하기
    func requestSessionKey(param: Parameters, completion: @escaping (Result<PloggingUser, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.user,
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: temp
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
}

// MARK: - PLOGGING
extension APICollection {
    func requestTest(completion: @escaping () -> Void) {
        let header: HTTPHeaders = ["sessionKey": "_zfYaHZBM1URBKrJ7uOTl1FVRQRfGQ8F",
                                   "cookie": "connect.sid=s%3A_zfYaHZBM1URBKrJ7uOTl1FVRQRfGQ8F.zapHpj9aUTZSpBQ2IuXyVQRtS3aUw8D%2Flr61ZYSesYE"]

        let data = "{\"meta\": { \"distance\": 100, \"calorie\": 200, \"flogging_time\": 20 }, \"pick_list\": [{ \"trash_type\": 3, \"pick_count\": 33 }, { \"trash_type\": 1, \"pick_count\": 12 }]}"

        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(Data(data.utf8), withName: "ploggingData")
        },
        to: BaseURL.mainURL + BasePath.plogging,
        method: .post,
        headers: header
        ).responseJSON { response in
            print(response)
            guard let data = response.data else {
                print(APIError.dataFailed)
                return completion()
            }

            print(data)
            completion()
        }
    }
}

// MARK: - RANKING
extension APICollection {
    func requestGlobalRanking(param: Parameters, completion: @escaping (Result<RankingGlobal, APIError>) -> Void) {
        let header: HTTPHeaders = ["sessionKey": "세션키 넣어라",
                                   "Content-Type": "application/json"]
        
        AF.request(BaseURL.mainURL + BasePath.rankingGlobal,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.default,
                   headers: header
        ).responseJSON { (response) in
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }

            guard let value = try? JSONDecoder().decode(RankingGlobal.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
    }
    
    func requestUserRanking(param: Parameters, completion: @escaping (Result<RankingUser, APIError>) -> Void) {
        let header: HTTPHeaders = ["sessionKey": "세션키 넣어라",
                                   "Content-Type": "application/json"]
        
        AF.request(BaseURL.mainURL + BasePath.rankUserId,
                   method: .get,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: header
        ).responseJSON { (response) in
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }

            guard let value = try? JSONDecoder().decode(RankingUser.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
    }
}
