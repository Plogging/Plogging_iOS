//
//  SNSLoginManager.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/07.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import NaverThirdPartyLogin
import AuthenticationServices
import Alamofire

class SNSLoginManager: NSObject {
    
    static let shared = SNSLoginManager()
    
    private var completion: ((SNSLoginData) -> Void)?

    // MARK: - setting up login
    func setupLoginWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func setupLoginWithKakao() {
        KakaoSDKCommon.initSDK(appKey: APIKey.kakaoLoginKey)
    }
    
    func setupLoginWithNaver() {
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        instance?.isNaverAppOauthEnable = true
        instance?.isInAppOauthEnable = true
                
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
    }
    
    // AMRK: - request login
    func requestLoginWithApple(completion: ((SNSLoginData) -> Void)?) {
        let loginData = SNSLoginData()
        
        completion?(loginData)
    }
    
    func requestLoginWithKakao(completion: ((SNSLoginData) -> Void)?) {
        if AuthApi.isKakaoTalkLoginAvailable() {
            AuthApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    let loginData: SNSLoginData = SNSLoginData()
                    loginData.token = oauthToken?.accessToken ?? ""
                    completion?(loginData)
                    self.getKakaoInfo()
                }
            }
        } else {
            AuthApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    let loginData: SNSLoginData = SNSLoginData()
                    loginData.token = oauthToken?.accessToken ?? ""
                    completion?(loginData)
                    self.getKakaoInfo()
                }
            }
        }
    }
    
    func requestLoginWithNaver(completion: ((SNSLoginData) -> Void)?) {
        guard let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance() else {
            return
        }

        loginInstance.delegate = self
        loginInstance.requestThirdPartyLogin()
        
        let loginData = SNSLoginData()
        
        completion?(loginData)
        getNaverInfo()
    }
    
    // MARK: - getting user info
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userFirstName = appleIDCredential.fullName?.givenName ?? ""
            let userLastName = appleIDCredential.fullName?.familyName ?? ""
            let userName = userLastName + userFirstName
            let userEmail = appleIDCredential.email
            print("userName \(userName) userFirstName \(userFirstName), userLastName \(userLastName), userEmail \(userEmail!)")
            SNSLoginManager.shared.loginSuccess(type: "apple", email: userEmail!)
        default:
            break
        }
    }
    
    func getNaverInfo() {
        guard let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance() else {
            return
        }
        
        if !loginInstance.isValidAccessTokenExpireTimeNow() { return }

        guard let tokenType = loginInstance.tokenType else { return }
        guard let accessToken = loginInstance.accessToken else { return }
        guard let url = URL(string: Naver.Info.rawValue) else { return }
        
        let authorization = "\(tokenType) \(accessToken)"
        
        AF.request(url,method: .get, headers: ["Authorization": authorization]).responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let name = object["name"] as? String else { return }
            guard let email = object["email"] as? String else { return }
            print("name: \(name), email: \(email)")
            self.loginSuccess(type: "naver", email: email)
        }
    }
    
    func getKakaoInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")

                if let name = user?.kakaoAccount?.legalName, let email = user?.kakaoAccount?.email {
                    print("name \(name)")
                    print("email \(email)")
                    self.loginSuccess(type: "kakao", email: email)
                }
            }
        }
    }
        
    // MARK: - success
    func loginSuccess(type: String, email: String) {
        let parameters: [String: Any] = [
            "type" : type,
            "email" : email,
        ]
        
        APICollection.sharedAPI.requestSessionKey(param: parameters) { (result) in
            if let sessionKey = try? result.get().session {
                UserDefaults.standard.set(sessionKey, forKey: "sessionKey")
                print("success")
            }
        }
    }
}

// MARK: - NAVER Delegate
extension SNSLoginManager: NaverThirdPartyLoginConnectionDelegate {
    
    private func completionNaverLogin() {
        guard let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance() else {
            return
        }
        
        let loginData: SNSLoginData = SNSLoginData()
        loginData.token = loginInstance.accessToken ?? ""
        completion?(loginData)
    }
    
    // 로그인에 성공했을 경우 호출    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print(oauth20ConnectionDidFinishRequestACTokenWithAuthCode)
        
        completionNaverLogin()
        getNaverInfo()
    }
    
    // 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("토큰 갱신")
        completionNaverLogin()
    }
    
    // 로그아웃 할 경우 호출
    func oauth20ConnectionDidFinishDeleteToken() {
        print("토큰 삭제")
        completionNaverLogin()
    }
    
    // ERROR
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error ?? "error occured")
    }
}

// MARK: - APPLE Delegate
extension SNSLoginManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}

extension SNSLoginManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }
}
