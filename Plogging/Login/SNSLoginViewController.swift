//
//  SNSLoginViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/05.
//

import UIKit
import Alamofire
import AuthenticationServices
import NaverThirdPartyLogin
import KakaoSDKAuth
import KakaoSDKUser

class SNSLoginViewController: UIViewController {

    @IBOutlet weak var snsLoginStackView: UIStackView!
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNaverLoginButton()
        setupKakaoLoginButton()
        setupAppleLoginButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performExistingAccountSetupFlows()
    }
    
    // MARK: - Connect SNS Login

    // MARK: - NAVER
    func setupNaverLoginButton() {
        loginInstance?.delegate = self
    }
    
    func getNaverInfo() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
            return
        }
        
        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let name = object["name"] as? String else { return }
            guard let email = object["email"] as? String else { return }
            print("name: \(name), email: \(email)")
        }
    }
    
    // MARK: - KAKAO
    func setupKakaoLoginButton() {
        
    }
    
    // MARK: - APPLE
    
    func setupAppleLoginButton() {
        let authorizationAppleButton = ASAuthorizationAppleIDButton()
        authorizationAppleButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.snsLoginStackView.addArrangedSubview(authorizationAppleButton)
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @IBAction func clickNaverLoginButton(_ sender: UIButton) {
        loginInstance?.requestThirdPartyLogin()
    }
    
    @IBAction func clickKakaoLoginButton(_ sender: UIButton) {
        if AuthApi.isKakaoTalkLoginAvailable() {
            AuthApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("success \(oauthToken)")
                }
            }
        }
    }
}

// MARK: - Apple Delegate
extension SNSLoginViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print(appleIDCredential)
        case let passwordCredential as ASPasswordCredential:
            print(passwordCredential)
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // error.
    }
}

extension SNSLoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// MARK: - NAVER Delegate
extension SNSLoginViewController: NaverThirdPartyLoginConnectionDelegate {
    // 로그인에 성공했을 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print(oauth20ConnectionDidFinishRequestACTokenWithAuthCode)
        getNaverInfo()
    }
    
    // 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("토큰 갱신")
    }
    
    // 로그아웃 할 경우 호출
    func oauth20ConnectionDidFinishDeleteToken() {
        print("토큰 삭제")
        loginInstance?.requestDeleteToken()
    }
    
    // ERROR
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error ?? "error occured")
    }
}
