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
    
    func gettingHeader() -> HTTPHeaders {
        if let cookie = PloggingCookie.shared.getUserCookie() {
            return [
                "cookie": "\(cookie)",
//                "Content-Type": "application/json",
//                "accept" : "application/json",
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
        } else {
            return [
                "Content-Type": "application/json"
            ]
        }
    }

    let defaultHeader: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
}

// MARK: - USER
extension APICollection {
    /// SNS 로그인
    func requestSignInSocial(param: Parameters, completion: @escaping (Result<PloggingUser, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.userSocial,
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: defaultHeader
        ).responseJSON { response in
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }

            print(response)
            guard let value = try? JSONDecoder().decode(PloggingUser.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
    }
    
    /// 자체 로그인
    func requestSignInCustom(param: Parameters, completion: @escaping (Result<PloggingUser, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.userSignIn,
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: defaultHeader
        ).responseJSON { response in
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }
            print(response)

            // 쿠키 설정
            if let cookieName = HTTPCookieStorage.shared.cookies?.first?.name, let cookieValue = HTTPCookieStorage.shared.cookies?.first?.value {
                DispatchQueue.main.async {
                    PloggingCookie.shared.setUserCookie(cookie: "\(cookieName)=\(cookieValue)")
                }
            }
            
            guard let value = try? JSONDecoder().decode(PloggingUser.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
    }

    /// 사용자 아이디 가입 확인
    func requestUserCheck(param: Parameters, completion: @escaping (Result<PloggingUser, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.userCheck,
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: defaultHeader
        ).responseJSON { response in
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }

            print(response)
            guard let value = try? JSONDecoder().decode(PloggingUser.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
    }

    /// 회원가입
    func requestUserSignUp(param: Parameters, completion: @escaping (Result<PloggingUser, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.userCheck,
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: defaultHeader
        ).responseJSON { response in
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }

            print(response)
            guard let value = try? JSONDecoder().decode(PloggingUser.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
    }
    
    /// 임시 비밀번호 발급
    func requestUserPasswordTemp(param: Parameters, completion: @escaping (Result<PloggingUser, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.userPasswordTemp,
                   method: .put,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: gettingHeader()
        ).responseJSON { response in
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }

            print(response)
            guard let value = try? JSONDecoder().decode(PloggingUser.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
    }
}

// MARK: - PLOGGING
extension APICollection {
    /// 플로깅 점수 계산
    func requestPloggingScore(param: Parameters, completion: @escaping (Result<PloggingInfo, APIError>) -> Void) {
//        let jsonString = "{\"meta\": { \"distance\": \"100\", \"calorie\": \"200\", \"plogging_time\": \"20\" }, \"trash_list\": [{ \"trash_type\": \"3\", \"pick_count\": \"33\" }, { \"trash_type\": \"1\", \"pick_count\": \"12\" }]}"
        guard let jsonString = param.toJsonString() else {
            return
        }
//        let params: [String: Any] = ["ploggingData" : jsonString]
        AF.request(BaseURL.mainURL + BasePath.ploggingScore,
                   method: .post,
                   parameters: ["ploggingData" : jsonString],
                   encoding: URLEncoding(destination: .httpBody),
                   headers: gettingHeader()
        ).responseJSON { response in
            print(response)
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }
            print(data)
            guard let value = try? JSONDecoder().decode(PloggingInfo.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }

            completion(.success(value))
        }
    }
    
    /// 플로깅 결과 등록
    func requestRegisterPloggingResult(param: Parameters, imageData: Data, completion: @escaping (Result<PloggingInfo, APIError>) -> Void) {
        AF.upload(multipartFormData: { (multipartFormData) in
            guard let jsonString = param.toJsonString() else {
                return
            }
            print("jsonString: \(jsonString)")
            multipartFormData.append(Data(jsonString.utf8), withName: "ploggingData")
            multipartFormData.append(imageData, withName: "ploggingImg", fileName: "ploggingImage.jpg", mimeType: "image/png")
        },
        to: BaseURL.mainURL + BasePath.plogging,
        method: .post,
        headers: gettingHeader()
        ).responseJSON { response in
            print(response)
            guard let data = response.data else {
                print(APIError.dataFailed)
                return completion(.failure(.dataFailed))
            }
            print(data)
            guard let value = try? JSONDecoder().decode(PloggingInfo.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            completion(.success(value))
        }
    }
    
    /// 플로깅 결과 조회
    func requestGetPloggingResult(param: Parameters, completion: @escaping (Result<PloggingInfo, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.ploggingResult,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.default,
                   headers: gettingHeader()
        ).responseJSON { (response) in
            print(response)
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }
            print(data)
            guard let value = try? JSONDecoder().decode(PloggingInfo.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
    }
    
    /// 플로깅 결과 삭제
    func deletePloggingRecord() {
        
    }
}

// MARK: - RANKING
extension APICollection {
    func requestGlobalRanking(param: Parameters, completion: @escaping (Result<RankingGlobal, APIError>) -> Void) {
        
        AF.request(BaseURL.mainURL + BasePath.rankingGlobal,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.default,
                   headers: gettingHeader()
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
    
    // URL에 id(path variable)추가
    func requestUserRanking(param: Parameters, completion: @escaping (Result<RankingUser, APIError>) -> Void) {        
        AF.request(BaseURL.mainURL + BasePath.rankUserId,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.default,
                   headers: gettingHeader()
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
