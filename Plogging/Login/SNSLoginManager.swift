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

class SNSLoginManager: NSObject {
    
    static let shared = SNSLoginManager()
    
    private var completion: ((SNSLoginData) -> Void)?

    func setupLoginWithNaver() {
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        instance?.isNaverAppOauthEnable = true
        instance?.isInAppOauthEnable = true
                
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
    }
    
    func setupLoginWithKakao() {
        KakaoSDKCommon.initSDK(appKey: APIKey.kakaoLoginKey)
    }
    
    func setupLoginWithApple() {
        
    }
    
    func requestLoginWithAPPLE(completion: ((SNSLoginData) -> Void)?) {
        let loginData = SNSLoginData()
        
        completion?(loginData)
    }
    
    func requestLoginWithKAKAO(completion: ((SNSLoginData) -> Void)?) {
        if AuthApi.isKakaoTalkLoginAvailable() {
            AuthApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    let loginData: SNSLoginData = SNSLoginData()
                    loginData.token = oauthToken?.accessToken ?? ""
                    completion?(loginData)
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
                }
            }
        }
    }
    
    func requestLoginWithNAVER(completion: ((SNSLoginData) -> Void)?) {
        guard let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance() else {
            return
        }

        loginInstance.delegate = self
        loginInstance.requestThirdPartyLogin()
        
        let loginData = SNSLoginData()
        
        completion?(loginData)
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
extension SNSLoginManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }
}
