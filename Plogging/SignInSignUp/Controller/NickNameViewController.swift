//
//  NickNameViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/31.
//

import UIKit

class NickNameViewController: UIViewController {

    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nickNameInfoLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    var userInfo = [String: Any]()
    
    private var ploggingUserInfo: PloggingUser? {
        didSet {
            checkValidation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextField()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupTextField() {
        nickNameTextField.delegate = self
    }
    
    private func setupUI() {
        confirmButton.clipsToBounds = true
        confirmButton.layer.cornerRadius = 12
        
        if let text = nickNameInfoLabel.text {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor.darkGray, range: (text as NSString).range(of:"9자까지"))
            nickNameInfoLabel.attributedText = attributedString
        }
    }

    private func setupErrorLabel(message: String?) {
        if message != nil {
            errorLabel.isHidden = false
            errorLabel.text = message
        } else {
            errorLabel.isHidden = true
        }
    }
    
    private func requestUserSignUp() {
        guard let nickName = nickNameTextField.text else { return }
        
        userInfo.updateValue(nickName, forKey: "userName")
        
        APICollection.sharedAPI.requestUserSignUp(param: userInfo) { (response) in
            self.ploggingUserInfo = try? response.get()
        }
    }
    
    private func checkValidation() {
        guard let model = ploggingUserInfo else {
            return
        }
        switch model.rc {
        case 201:
            makeDefaultRootViewController()
            return
        case 409:
            setupErrorLabel(message: "이미 사용중인 이메일입니다.")
            return
        case 410:
            setupErrorLabel(message: "이미 사용중인 닉네임입니다.")
            return
        default:
            print("error")
            return
        }
    }
    
    
    @IBAction func clickConfirmButton(_ sender: UIButton) {
        guard let nickName = nickNameTextField.text else { return }
        if nickName.count > 0 {
            // reqeust API
            requestUserSignUp()
        }
    }
}

extension NickNameViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nickNameInfoLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            nickNameInfoLabel.isHidden = false
        }
    }
}
