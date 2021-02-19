//
//  ChangePasswordViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/02/09.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var nowPasswordOuterView: UIView!
    @IBOutlet weak var nowPasswordTextField: UITextField!
   
    @IBOutlet weak var changePasswordOuterView: UIView!
    @IBOutlet weak var changePasswordTextField: UITextField!
    
    @IBOutlet weak var checkPasswordOuterView: UIView!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var isValidate: Bool = false {
        didSet {
            if isValidate {
                confirmButton.backgroundColor = UIColor.tintGreen
            } else {
                confirmButton.backgroundColor = UIColor.loginGray
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action:#selector(handlePopGesture))
        
        nowPasswordTextField.delegate = self
        changePasswordTextField.delegate = self
        checkPasswordTextField.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupUI() {
        setNavigationBarClear()
        
        nowPasswordOuterView.clipsToBounds = true
        changePasswordOuterView.clipsToBounds = true
        checkPasswordOuterView.clipsToBounds = true
        confirmButton.clipsToBounds = true
        
        nowPasswordOuterView.layer.cornerRadius = 4
        changePasswordOuterView.layer.cornerRadius = 4
        checkPasswordOuterView.layer.cornerRadius = 4
        confirmButton.layer.cornerRadius = 4
        
        nowPasswordTextField.isSecureTextEntry = true
        changePasswordTextField.isSecureTextEntry = true
        checkPasswordTextField.isSecureTextEntry = true
    }
    
    @objc func handlePopGesture(gesture: UIGestureRecognizer) -> Void {
        if gesture.state == UIGestureRecognizer.State.began {
            (rootViewController as? MainViewController)?.setTabBarHidden(true)
        }
    }
    
    @IBAction func completeChangePassword(_ sender: Any) {
        guard let newSecretKey = nowPasswordTextField.text,
              let existedSecretKey = changePasswordTextField.text else {
            return
        }
        
        let param: [String: Any] = ["newSecretKey": newSecretKey,
                                    "existedSecretKey": existedSecretKey]
        
        APICollection.sharedAPI.requestChangeUserPassword(param: param) { (response) in
            if let code = try? response.get().rc {
                switch code {
                case 200:
                    self.showPopUpViewController(with: .비밀번호변경완료팝업)
                    return
                case 404:
                    print("실패")
                    return
                default:
                    print("error")
                    return
                }
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    private func checkValidation() {
        guard let pass = nowPasswordTextField.text else {
            return
        }
        
        if let message = checkPasswordValidation(password: pass) {
            setupWarningLabel(message: message)
            return
        }
        
        guard let pass1 = changePasswordTextField.text else {
            return
        }
        
        if let message = checkPasswordValidation(password: pass1) {
            setupWarningLabel(message: message)
            return
        }

        guard let pass2 = checkPasswordTextField.text else {
            return
        }
               
        if let message = checkPasswordEqual(pass1, pass2) {
            setupWarningLabel(message: message)
            return
        }
        
        isValidate = true
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidation()
    }
}

extension ChangePasswordViewController: LoginValidation {}
