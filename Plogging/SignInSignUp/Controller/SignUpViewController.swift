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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
            self.performSegue(withIdentifier: SegueIdentifier.nickNameViewController,
                              sender: nil)
        case 201:
            setupWarningLabel(message: "아이디가 존재합니다.")
            return
        default:
            print("error")
            return
        }
    }
    
    private func setupUI() {
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
    
    private func setupTextFieldDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
    }
    
    private func setupWarningLabel(message: String?) {
        if message != nil {
            isValidate = false
            warningLabel.isHidden = false
            warningLabel.text = message
        } else {
            warningLabel.isHidden = true
        }
    }
    
    private func setupViewRoundBorder(_ layer: CALayer, _ valid: Bool) {
        layer.borderWidth = 1
        if valid {
            layer.borderColor = UIColor.tintGreen.cgColor
        } else {
            layer.borderColor = UIColor.strawberry.cgColor
        }
    }
    
    private func checkAllValidation(_ textField: UITextField) {
        // 이메일 체크
        if let email = emailTextField.text {
            if let message = checkEmailVaidation(email: email) {
                setupWarningLabel(message: message)
                emailView.unvalid()
                return
            }
            setupWarningLabel(message: nil)
            emailView.valid()
        }
        
        // 비밀번호 validation check 8자 이상
        if let password = passwordTextField.text {
            if let message = checkPasswordValidation(password: password) {
                if password.count < 8 {
                    setupWarningLabel(message: message)
                    passwordView.unvalid()
                    return
                }
                setupWarningLabel(message: message)
                passwordView.unvalid()
                return
            }
            setupWarningLabel(message: nil)
            passwordView.valid()
        }
        
        // 비밀번호 동일한지 체크
        if let pass1 = passwordTextField.text,
           let pass2 = passwordCheckTextField.text {
            if let message = checkPasswordEqual(pass1, pass2) {
                setupWarningLabel(message: message)
                passwordCheckView.unvalid()
                return
            }
            setupWarningLabel(message: nil)
            passwordCheckView.valid()
        }
        
        isValidate = true
    }
    
    @IBAction func clickSignUpButton(_ sender: UIButton) {
        if isValidate {
            requestUserCheck()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkAllValidation(textField)

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        checkAllValidation(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignUpViewController: LoginValidation {}
