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
            checkAPIResponse()
        }
    }
    private var isValidate: Bool = false {
        didSet {
            if isValidate {
                signInButton.backgroundColor = UIColor.tintGreen
            } else {
                signInButton.backgroundColor = UIColor.loginGray
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupDelegate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupUI() {
        emailView.clipsToBounds = true
        emailView.layer.cornerRadius = 4
        
        passwordView.clipsToBounds = true
        passwordView.layer.cornerRadius = 4
        passwordTextField.isSecureTextEntry = true
        
        signInButton.clipsToBounds = true
        signInButton.layer.cornerRadius = 12
    }
    
    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
    
    private func checkAPIResponse() {
        guard let model = ploggingUserInfo else {
            return
        }
        switch model.rc {
        case 200:
            errorLabel.isHidden = true
            makeDefaultRootViewController()
            return
        case 400, 401:
            errorLabel.isHidden = false
            errorLabel.text = "가입되지 않은 정보이거나 비밀번호가 다릅니다."
            return
        default:
            print("error")
            return
        }
    }
    
    private func setupWarningLabel(message: String?) {
        if message != nil {
            isValidate = false
            errorLabel.isHidden = false
            errorLabel.text = message
        } else {
            errorLabel.isHidden = true
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 이메일 체크
        if let email = emailTextField.text {
            if let message = checkEmailVaidation(email: email) {
                setupWarningLabel(message: message)
                return
            }
            setupWarningLabel(message: nil)
        }
        
        // 비밀번호 validation check 8자 이상
        if let password = passwordTextField.text {
            if let message = checkPasswordValidation(password: password) {
                if password.count < 8 {
                    setupWarningLabel(message: message)
                    return
                }
                setupWarningLabel(message: message)
                return
            }
            setupWarningLabel(message: nil)
        }
        
        isValidate = true
    }
}

extension LoginViewController: LoginValidation {}
