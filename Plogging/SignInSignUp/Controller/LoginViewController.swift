//
//  LoginViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var ploggingUserInfo: PloggingUser? {
        didSet {
            checkValidation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupUI() {
        emailView.clipsToBounds = true
        emailView.layer.cornerRadius = 4
        
        passwordView.clipsToBounds = true
        passwordView.layer.cornerRadius = 4
        passwordTextField.isSecureTextEntry = true
        
        signInButton.clipsToBounds = true
        signInButton.layer.cornerRadius = 12
    }
    
    @IBAction func clickedFindPasswordButton(_ sender: UIButton) {

    }
    
    @IBAction func clickConfirmButton(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }

        let param: [String: Any] = [
            "userId": email,
            "secretKey": password
        ]
        
        APICollection.sharedAPI.requestSignInCustom(param: param) { (response) in
            self.ploggingUserInfo = try? response.get()
        }
    }
    
    private func checkValidation() {
        guard let model = ploggingUserInfo else {
            return
        }
        switch model.rc {
        case 400, 401:
            errorLabel.isHidden = false
            errorLabel.text = "가입되지 않은 정보이거나 비밀번호가 다릅니다."
            return
        case 500:
            print("서버 error")
            return
        default:
            print("success")
            errorLabel.isHidden = true
            makeDefaultRootViewController()
            return
        }
    }
    
    @IBAction func clickedKakaoLoginButton(_ sender: UIButton) {
        SNSLoginManager.shared.requestLoginWithKakao { (loginData) in
            print(loginData)
        }
    }
    
    @IBAction func clickedNaverLoginButton(_ sender: UIButton) {
        SNSLoginManager.shared.requestLoginWithNaver { (loginData) in
            print(loginData)
        }
    }

    @IBAction func clickedAppleLoginButton(_ sender: UIButton) {
        SNSLoginManager.shared.setupLoginWithApple()
    }
}
