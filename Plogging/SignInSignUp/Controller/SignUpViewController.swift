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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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
    
    func setupWarningLabel(message: String?) {
        if message != nil {
            warningLabel.isHidden = false
            warningLabel.text = message
        } else {
            warningLabel.isHidden = true
        }
    }
    
    @IBAction func clickSignUpButton(_ sender: UIButton) {
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            let waring = checkWarningValidation(email: email, password: password)
            if waring == nil {
                setupWarningLabel(message: nil)
                requestUserCheck()
            } else {
                setupWarningLabel(message: waring)
            }
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let pass1 = passwordTextField.text, let pass2 = passwordCheckTextField.text, pass1.count > 7, pass2.count > 7 else {
            return
        }
        
        if checkPasswordEqual(pass1, pass2) {
            setupWarningLabel(message: nil)
        } else {
            setupWarningLabel(message: "입력하신 비밀번호와 일치하지 않습니다.")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignUpViewController: LoginValidation {}
