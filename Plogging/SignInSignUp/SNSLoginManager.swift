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

    func callCompleteLoginNoti(result: PloggingUser?, param: [String: Any]) {
        var info = param
        if let result = result {
            info.updateValue(result, forKey: "result")
        }
        NotificationCenter.default.post(name: .loginCompletion, object: nil, userInfo: info)
    }
    
    // MARK: - setting up login
    func setupLoginWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
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
    
    func requestLoginWithKakao(completion: ((SNSLoginData) -> Void)?) {
        if AuthApi.isKakaoTalkLoginAvailable() {
            AuthApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    self.getKakaoInfo()
                    let loginData: SNSLoginData = SNSLoginData()
                    completion?(loginData)
                }
            }
        } else {
            AuthApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    self.getKakaoInfo()
                    let loginData: SNSLoginData = SNSLoginData()
                    completion?(loginData)
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
    }
    
    func getNaverInfo() {
        guard let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance() else {
            return
        }
        
        guard let tokenType = loginInstance.tokenType else { return }
        guard let accessToken = loginInstance.accessToken else { return }
        guard let url = URL(string: Naver.Info.rawValue) else { return }
        
        let authorization = "\(tokenType) \(accessToken)"
        
        AF.request(url,
                   method: .get,
                   headers: ["Authorization": authorization]
        ).responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let email = object["email"] as? String,
                  let name = object["name"] as? String else { return }
            print("email: \(email)")
            self.requestSNSLogin(email: email, name: name, type: SNSType.naver.rawValue)
        }
    }
    
    func getKakaoInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                if let email = user?.kakaoAccount?.email,
                   let name = user?.kakaoAccount?.profile?.nickname {
                    print("email \(email)")
                    self.requestSNSLogin(email: email, name: name, type: SNSType.kakao.rawValue)
                }
            }
        }
    }
        
    func requestSNSLogin(email: String, name: String, type: String) {
        
        let param: [String: Any] = [
            "userId": "\(email):\(type)",
            "userName": name
        ]

        APICollection.sharedAPI.requestSignInSocial(param: param) { (response) in
            if let response = try? response.get() {
                self.callCompleteLoginNoti(result: response, param: param)
            }
        }
    }
}

// MARK: - NAVER Delegate
extension SNSLoginManager: NaverThirdPartyLoginConnectionDelegate {
    // 로그인에 성공했을 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("성공")
        print(oauth20ConnectionDidFinishRequestACTokenWithAuthCode)
        
        getNaverInfo()

        let loginData: SNSLoginData = SNSLoginData()
        loginData.type = SNSType.naver.rawValue
        completion?(loginData)
    }
    
    // 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("토큰 갱신")
        getNaverInfo()
    }
    
    // 로그아웃 할 경우 호출
    func oauth20ConnectionDidFinishDeleteToken() {
        print("토큰 삭제")
        NaverThirdPartyLoginConnection.getSharedInstance()?.requestDeleteToken()
    }
    
    // ERROR
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error ?? "error occured")
    }
}

// MARK: - APPLE Delegate
extension SNSLoginManager: ASAuthorizationControllerDelegate {
    // MARK: - getting user info
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let email = appleIDCredential.email,
               let given = appleIDCredential.fullName?.givenName, let family = appleIDCredential.fullName?.familyName {
                PloggingUserData.shared.setAppleUserIdentifier(indentifier: appleIDCredential.user)
                self.requestSNSLogin(email: email, name: family+given,
                                          type: SNSType.apple.rawValue)
                break;
            }
            validChcekApple()
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
    func validChcekApple() {
        if let userIdentifier = PloggingUserData.shared.getAppleUserIdentifier() {
            let authorizationProvider = ASAuthorizationAppleIDProvider()
            authorizationProvider.getCredentialState(forUserID: userIdentifier) { (state, error) in
                switch (state) {
                case .authorized:
                    print("Account Found - Signed In")
                    DispatchQueue.main.async { [self] in
                        callCompleteLoginNoti(result: nil, param: ["type":"apple"])
                    }
                    break
                case .revoked:
                    print("다른 방법으로 로그인 해주세요.")
                    fallthrough
                case .notFound:
                    print("다른 방법으로 로그인 해주세요.")
                default:
                    break
                }
            }
        }
    }
}

extension SNSLoginManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }
}
