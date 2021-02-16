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
    // SNS 로그인
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var naverLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    // 자체 회원가입 및 로그인
    @IBOutlet weak var signUpWithEmailButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    // 이용 약관
    @IBOutlet weak var informationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarClear()
        setupButtonsUI()
        setupInformation()
        setupNotification()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .loginCompletion, object: nil)
    }

    @objc func onDidReceiveData(_ notification: Notification)
    {
        if let data = notification.userInfo as? [String: Any] {
            if let rc = data["rc"] as? Int, let userId = data["userId"] as? String {
                moveToOtherPage(rc, userId)
            }            
        }
    }
    
    func moveToOtherPage(_ rc: Int, _ id: String) {
        switch rc {
        case 200:
            let storyboard = UIStoryboard(name: "SNSLogin", bundle: nil)
            if let viewcontroller = storyboard.instantiateViewController(identifier: SegueIdentifier.nickNameViewController) as? NickNameViewController {
                viewcontroller.loginType = "SNS"
                viewcontroller.userInfo = ["userId": id]
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            }
            return
        case 400:
            // 이미 가입된 유저
            // /user/social를 호출
            return
        default:
            print("error")
        }
    }
    
    func setupButtonsUI() {
        kakaoLoginButton.clipsToBounds = true
        kakaoLoginButton.layer.cornerRadius = 12
        
        naverLoginButton.clipsToBounds = true
        naverLoginButton.layer.cornerRadius = 12
        
        appleLoginButton.clipsToBounds = true
        appleLoginButton.layer.cornerRadius = 12
        
        kakaoLoginButton.marginImageWithText(margin: 82)
        naverLoginButton.marginImageWithText(margin: 82)
        appleLoginButton.marginImageWithText(margin: 82)
        
        signUpWithEmailButton.clipsToBounds = true
        signUpWithEmailButton.layer.cornerRadius = 12

        signInButton.clipsToBounds = true
        signInButton.layer.cornerRadius = 12
    }
    
    private func setupInformation() {
        let text = "로그인하여 에코런 서비스 이용약관, 에코런 개인정보수집이용, 에코런 개인정보제공에 동의합니다."
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)], range: (text as NSString).range(of: text))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], range: (text as NSString).range(of: text))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: (text as NSString).range(of:"에코런 서비스 이용약관, 에코런 개인정보수집이용, 에코런 개인정보제공"))
        attributedString.addAttribute(.underlineColor, value: UIColor.darkGray, range: (text as NSString).range(of:"에코런 서비스 이용약관, 에코런 개인정보수집이용, 에코런 개인정보제공"))

        informationButton.setAttributedTitle(attributedString, for: .normal)
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
    
    @IBAction func clickAppleLoginButton(_ sender: UIButton) {
        SNSLoginManager.shared.setupLoginWithApple()
    }
    
    @IBAction func clickSignUpWithEmailButton(_ sender: UIButton) {

    }
    
    @IBAction func clickSignInButton(_ sender: UIButton) {

    }
}
