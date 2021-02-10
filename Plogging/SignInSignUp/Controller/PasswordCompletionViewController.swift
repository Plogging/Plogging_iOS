//
//  PasswordCompletionViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/03.
//

import UIKit

class PasswordCompletionViewController: UIViewController {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    private var ploggingInfo: PloggingUser? {
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

    private func setupUI() {
        confirmButton.clipsToBounds = true
        confirmButton.layer.cornerRadius = 12
        
        emailView.clipsToBounds = true
        emailView.layer.cornerRadius = 4
        
        passwordView.clipsToBounds = true
        passwordView.layer.cornerRadius = 4
        passwordTextField.isSecureTextEntry = true
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
            self.ploggingInfo = try? response.get()
        }
    }
    
    private func checkValidation() {
        guard let model = ploggingInfo else {
            return
        }
        switch model.rc {
        case 400, 401:
            errorLabel.isHidden = false
            errorLabel.text = "가입되지 않은 정보이거나 비밀번호가 다릅니다."
        case 500:
            print("서버 error")
        default:
            print("success")
            // 메인으로 이동
            makeDefaultRootViewController()
        }
    }
}
