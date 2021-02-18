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
    let defaultHeader: HTTPHeaders = ["Content-Type": "application/json"]

    func gettingHeader() -> HTTPHeaders {
        if let cookie = PloggingCookie.shared.getUserCookie() {
            return [
                "cookie": "\(cookie)",
                "Content-Type": "application/json"
            ]
        } else {
            return defaultHeader
        }
    }
    
    func gettingUrlencodedHeader() -> HTTPHeaders {
        if let cookie = PloggingCookie.shared.getUserCookie() {
            return [
                "cookie": "\(cookie)",
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
        } else {
            return defaultHeader
        }
    }
    func getCookies() {
        // 쿠키 설정
        if let cookieName = HTTPCookieStorage.shared.cookies?.first?.name, let cookieValue = HTTPCookieStorage.shared.cookies?.first?.value {
            DispatchQueue.main.async {
                PloggingCookie.shared.setUserCookie("\(cookieName)=\(cookieValue)")
            }
        }
    }
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
            
            // 쿠키 설정
            getCookies()
            
            
            
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
            getCookies()
            
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
        AF.request(BaseURL.mainURL + BasePath.user,
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
    
    /// 사용자 정보 가져오기
    func requestUserInfo(id: String, completion: @escaping (Result<PloggingUserInfo, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.user + "/\(id)",
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: gettingHeader()
        ).responseJSON { (response) in
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }

            guard let value = try? JSONDecoder().decode(PloggingUserInfo.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
    }
    
    /// 유저 이름 변경
    func requestChangeUserName(param: Parameters, completion: @escaping (Result<PloggingUser, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.userName,
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
    
    /// 비밀번호 변경
    func requestChangeUserPassword(param: Parameters, completion: @escaping (Result<PloggingUser, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.userPassword,
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
    
    /// 로그아웃
    func requestUserSignOut(completion: @escaping (Result<PloggingUser, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.userSignOut,
                   method: .put,
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
    
    /// 회원탈퇴
    func requestDeleteUser(completion: @escaping (Result<PloggingUser, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.user,
                   method: .delete,
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
    func requestPloggingScore(param: Parameters, completion: @escaping (Result<PloggingResultScore, APIError>) -> Void) {
        guard let jsonString = param.toJsonString() else {
            return
        }
        AF.request(BaseURL.mainURL + BasePath.ploggingScore,
                   method: .post,
                   parameters: ["ploggingData" : jsonString],
                   encoding: URLEncoding(destination: .httpBody),
                   headers: gettingUrlencodedHeader()
        ).responseJSON { response in
            print(response)
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }
            print(data)
            guard let value = try? JSONDecoder().decode(PloggingResultScore.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }

            completion(.success(value))
        }
    }
    
    /// 플로깅 결과 등록
    func requestRegisterPloggingResult(param: Parameters, imageData: Data, completion: @escaping (Result<PloggingResultBasicInfo, APIError>) -> Void) {
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
            guard let value = try? JSONDecoder().decode(PloggingResultBasicInfo.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            completion(.success(value))
        }
    }
    
    /// 플로깅 결과 삭제
    func deletePloggingRecord(id: String, ploggingImaegName: String, completion: @escaping (Result<PloggingResultBasicInfo, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.plogging + "?ploggingId=\(id)&ploggingImgName=\(ploggingImaegName)",
                   method: .delete,
                   headers: gettingHeader()
        ).responseJSON { (response) in
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }

            guard let value = try? JSONDecoder().decode(PloggingResultBasicInfo.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
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
    
    func requestUserRanking(id: String, param: Parameters, completion: @escaping (Result<RankingUser, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.rankUserId + "/\(id)",
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
