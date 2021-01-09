//
//  SNSLoginViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/05.
//

import UIKit
import Alamofire
import AuthenticationServices

class SNSLoginViewController: UIViewController {

    @IBOutlet weak var snsLoginStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNaverLoginButton()
        setupKakaoLoginButton()
        setupAppleLoginButton()
    }
    
    // MARK: - Connect SNS Login

    // MARK: - NAVER
    func setupNaverLoginButton() {
        
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
        SNSLoginManager.shared.handleAuthorizationAppleIDButtonPress()
    }
    
    @IBAction func clickNaverLoginButton(_ sender: UIButton) {
        SNSLoginManager.shared.requestLoginWithNaver { (loginData) in
            print(loginData)
        }
    }
    
    @IBAction func clickKakaoLoginButton(_ sender: UIButton) {
        SNSLoginManager.shared.requestLoginWithKakao { (loginData) in
            print(loginData)
        }
    }
}
