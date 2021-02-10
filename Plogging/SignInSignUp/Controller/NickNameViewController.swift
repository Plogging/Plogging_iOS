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
        case 200:
            print("success")
            makeDefaultRootViewController()
        case 400:
            print("userID이상")
            return
        case 401:
            if model.rcmsg.contains("UserId") {
                // userId 중복
                errorLabel.isHidden = false
            } else {
                // userName 중복
            }
            return
        case 500:
            print("서버 error")
            return
        default:
            print("error")
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
