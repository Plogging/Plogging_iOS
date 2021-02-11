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
                "Content-Type": "application/json"
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
    /// 플로깅 기록 등록하기
    func registerPloggingRecord(param: Parameters, image: UIImage, completion: @escaping (Result<PloggingInfo, APIError>) -> Void) {
        AF.upload(multipartFormData: { multipartFormData in
            if let imageData = image.jpegData(compressionQuality: 0.3) {
                print("imageData: \(image)")
                multipartFormData.append(imageData, withName: "ploggingImg", fileName: "image.jpg", mimeType: "image/jpeg")
            }
            
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
            }
        }, to: BaseURL.mainURL + BasePath.plogging, method: .post, headers: gettingHeader()).responseJSON { response in
//            switch response.result {
//            case .success(let JSON):
//                completion(nil, JSON)
//
//            case .failure(let error):
//                completion(error, nil)
//            }
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }
            print(String.init(data: data, encoding: .utf8))
            guard let value = try? JSONDecoder().decode(PloggingInfo.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
        
//        { encodingResult in
//            switch encodingResult {
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    completion(.success(response.result.value as Any))
//                }
//            case .failure(_):
//                print(EncodingError.Context.self)
//            }
//        }

//        AF.upload(multipartFormData: { multipartFormData in
//               multipartFormData.append(photoFilePath, withName: "live_image_file" , fileName: "capturedPhoto.jpg" , mimeType: "image/jpg")
//           }, to: url.appendingPathComponent(urlPart), headers: headers)
//               .responseJSON { response in
//                   switch response.result {
//                   case .success(let JSON):
//                       completion(nil, JSON)
//
//                   case .failure(let error):
//                       completion(error, nil)
//                   }
//           }
    }
    
    /// 플로깅 기록 가져오기
    func getPloggingRecord(completion: @escaping (Result<PloggingInfo, APIError>) -> Void) {
        AF.request(BaseURL.mainURL + BasePath.plogging,
                   method: .get,
                   headers: gettingHeader())
    }
    
    /// 플로깅 기록 삭제하기
    func deletePloggingRecord() {}
    
    
    func requestRegisterPloggingResult(param: Parameters, imageData: Data, completion: @escaping (Result<PloggingInfo, APIError>) -> Void) {
        AF.upload(multipartFormData: { (multipartFormData) in
            let json = param.toJsonString()
            print("json: \(json)")
            multipartFormData.append(Data(json!.utf8), withName: "ploggingData")
            
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
