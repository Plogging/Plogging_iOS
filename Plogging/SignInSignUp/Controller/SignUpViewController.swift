//
//  SignUpViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/18.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var passwordCheckView: UIView!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    private var ploggingInfo: PloggingUser? {
        didSet {
            checkEmailValidation()
        }
    }
    private var isValidate: Bool = false {
        didSet {
            if isValidate {
                signUpButton.backgroundColor = UIColor.tintGreen
            } else {
                signUpButton.backgroundColor = UIColor.loginGray
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTextFieldDelegate()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.nickNameViewController {
            if let nickNameViewController = segue.destination as? NickNameViewController,
               let email = emailTextField.text,
               let password = passwordTextField.text{
                nickNameViewController.userInfo = ["userId": email,
                                                   "secretKey": password]
            }
        }
     }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func requestUserCheck() {
        guard let email = emailTextField.text else {
            return
        }

        let param: [String: Any] = ["userId": email]
        
        APICollection.sharedAPI.requestUserCheck(param: param) { (response) in
            self.ploggingInfo = try? response.get()
        }
    }
    
    private func checkEmailValidation() {
        guard let model = ploggingInfo else {
            return
        }
        switch model.rc {
        case 200:
            print("success")
            self.performSegue(withIdentifier: SegueIdentifier.nickNameViewController,
                              sender: nil)
            
        case 400:
            warningLabel.isHidden = false
            warningLabel.text = "아이디가 존재합니다."
            return
        case 500:
            print("서버 error")
            return
        default:
            print("error")
        }
    }
    
    func setupUI() {
        emailView.clipsToBounds = true
        emailView.layer.cornerRadius = 4
        
        passwordView.clipsToBounds = true
        passwordView.layer.cornerRadius = 4
        passwordTextField.isSecureTextEntry = true
        
        passwordCheckView.clipsToBounds = true
        passwordCheckView.layer.cornerRadius = 4
        passwordCheckTextField.isSecureTextEntry = true
        
        signUpButton.clipsToBounds = true
        signUpButton.layer.cornerRadius = 12
    }
    
    func setupTextFieldDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
    }
    
    func setupWarningLabel(message: String?) {
        if message != nil {
            isValidate = false
            warningLabel.isHidden = false
            warningLabel.text = message
        } else {
            warningLabel.isHidden = true
        }
    }
    
    @IBAction func clickSignUpButton(_ sender: UIButton) {
        if isValidate {
            requestUserCheck()
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
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
        if let password = passwordTextField.text, password.count > 7 {
            if let message = checkPasswordValidation(password: password) {
                setupWarningLabel(message: message)
                return
            }
            setupWarningLabel(message: nil)
        }
        
        // 비밀번호 동일한지 체크
        if let pass1 = passwordTextField.text,
           let pass2 = passwordCheckTextField.text {
            if let message = checkPasswordEqual(pass1, pass2) {
                setupWarningLabel(message: message)
                return
            }
            setupWarningLabel(message: nil)
        }
        
        isValidate = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignUpViewController: LoginValidation {}
