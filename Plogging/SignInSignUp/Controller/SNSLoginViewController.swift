//
//  SNSLoginViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/05.
//

import UIKit
import Alamofire

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
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .loginCompletion, object: nil)
    }

    @objc func onDidReceiveData(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Any] {
            if let result = data["result"] as? PloggingUser,
               let userId = data["userId"] as? String {
                moveToOtherPage(result, userId)
            } else if let result = data["type"] as? String,
                      result == "apple" {
                // 애플로그인으로 들어오는 유저는 이 FLOW
                
                if let result = data["result"] as? PloggingUserInfo?,
                   let id = result?.userId,
                   let nickName = result?.userName,
                   let image = result?.userImg {
                    // 200
                    PloggingUserData.shared.saveUserData(id: id,
                                                         nickName: nickName,
                                                         image: image)
                    makeDefaultRootViewController()
                } else {
                    showPopUpViewController(with: .애플로그인재설정)
                }
            }
        }
    }
    
    func moveToOtherPage(_ result: PloggingUser, _ id: String) {
        switch result.rc {
        case 200, 201:
            if let nickName = result.userName, let image = result.userImg {
                if nickName.count > 9 {
                    let storyboard = UIStoryboard(name: Storyboard.SNSLogin.rawValue, bundle: nil)
                    if let viewcontroller = storyboard.instantiateViewController(identifier: SegueIdentifier.nickNameViewController) as? NickNameViewController {
                        viewcontroller.loginType = "SNS"
                        viewcontroller.userInfo = ["userId": id]
                        self.navigationController?.pushViewController(viewcontroller, animated: true)
                    }
                } else {
                    PloggingUserData.shared.saveUserData(id: id,
                                                         nickName: nickName,
                                                         image: image)
                }
            }
            makeDefaultRootViewController()
            return
        case 409:
            let storyboard = UIStoryboard(name: Storyboard.SNSLogin.rawValue, bundle: nil)
            if let viewcontroller = storyboard.instantiateViewController(identifier: SegueIdentifier.nickNameViewController) as? NickNameViewController {
                viewcontroller.loginType = "SNS"
                viewcontroller.userInfo = ["userId": id]
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            }
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
        SNSLoginManager.shared.setupLoginWithNaver()
        SNSLoginManager.shared.requestLoginWithNaver { (loginData) in
            print(loginData)
        }
    }
    
    @IBAction func clickKakaoLoginButton(_ sender: UIButton) {
        SNSLoginManager.shared.setupLoginWithKakao()
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
