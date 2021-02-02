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
    
    let plogging: HTTPHeaders = ["accept":"application/json",
//                                 "sessionKey":"\(UserDefaults.standard.bool(forKey: "sessionKey"))",
                                 "sessionKey":"",
                                 "Content-Type": "multipart/form-data"]

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
        }, to: BaseURL.mainURL + BasePath.plogging, method: .post, headers: plogging).responseJSON { response in
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
                   headers: temp
        ).responseJSON { response in
            guard let data = response.data else {
                return completion(.failure(.dataFailed))
            }

            guard let value = try? JSONDecoder().decode(PloggingInfo.self, from: data) else {
                return completion(.failure(.decodingFailed))
            }
            
            completion(.success(value))
        }
    }
   
    /// 플로깅 기록 삭제하기
    func deletePloggingRecord() {
        
    }
}
