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
    @IBOutlet weak var signUpButton: UIButton!
    
    private var ploggingInfo: PloggingUser? {
        didSet {
            checkEmailValidation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNotification()
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
    
    func addNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
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
        
        signUpButton.clipsToBounds = true
        signUpButton.layer.cornerRadius = 12
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {

    }
    
    @objc func keyboardWillHide(_ notification: Notification) {

    }
    
    @IBAction func clickSignUpButton(_ sender: UIButton) {
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            let waring = checkWarningValidation(email: email, password: password)
            if waring == nil {
                warningLabel.isHidden = true
                requestUserCheck()
            } else {
                warningLabel.isHidden = false
                warningLabel.text = waring
            }
        }
    }
}

extension SignUpViewController: LoginValidation {}
