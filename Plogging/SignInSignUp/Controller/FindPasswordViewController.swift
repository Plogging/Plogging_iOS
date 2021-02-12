//
//  FindPasswordViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/31.
//

import UIKit

class FindPasswordViewController: UIViewController {

    @IBOutlet var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

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
    }
    
    private func setupWarningLabel(message: String?) {
        if message != nil {
            errorLabel.isHidden = false
            errorLabel.text = message
        } else {
            errorLabel.isHidden = true
        }
    }
    
    @IBAction func clickConfirmButton(_ sender: UIButton) {
        guard let email = emailTextField.text else {
            return
        }

        // reqeust API
        let param: [String: Any] = ["email": email]
        
        APICollection.sharedAPI.requestUserPasswordTemp(param: param) { (response) in
            if let code = try? response.get().rc {
                switch code {
                case 200:
                    self.performSegue(withIdentifier: SegueIdentifier.passwordCompletionViewController, sender: nil)
                    return
                case 404:
                    self.setupWarningLabel(message: "유효하지 않은 이메일입니다.")
                    return
                default:
                    print("error")
                    return
                }
            }
        }
    }
}

extension FindPasswordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 이메일 체크
        if let email = emailTextField.text {
            if let message = checkEmailVaidation(email: email) {
                setupWarningLabel(message: message)
                confirmButton.backgroundColor = UIColor.loginGray
                return
            }
            setupWarningLabel(message: nil)
            confirmButton.backgroundColor = UIColor.tintGreen
        }
    }
}

extension FindPasswordViewController: LoginValidation {}
