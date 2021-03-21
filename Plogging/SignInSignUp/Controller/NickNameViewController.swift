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
    
    var myNickName = ""
    var loginType = ""
    var userInfo = [String: Any]()
    
    private var ploggingUserInfo: PloggingUser? {
        didSet {
            checkValidation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if loginType == "SETTING" {
            setNavigationBarClear()
            confirmButton.setTitle("저장", for: .normal)
        }
        setupTextField()
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
    
    private func setupTextField() {
        nickNameTextField.delegate = self
    }
    
    private func setupUI() {
        if myNickName.count >= 1 {
            nickNameInfoLabel.isHidden = true
            nickNameTextField.text = myNickName
        } 
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
        
        if loginType == "SNS" {
            APICollection.sharedAPI.requestSignInSocial(param: userInfo) { (response) in
                self.ploggingUserInfo = try? response.get()
            }
        } else if loginType == "SETTING" {
            let param = ["userName": nickName]
            APICollection.sharedAPI.requestChangeUserName(param: param) { (response) in
                self.ploggingUserInfo = try? response.get()
            }
        } else {
            APICollection.sharedAPI.requestUserSignUp(param: userInfo) { (response) in
                self.ploggingUserInfo = try? response.get()
            }
        }
    }
    
    private func checkValidation() {
        guard let model = ploggingUserInfo else {
            return
        }
        if loginType == "SNS" {
            switch model.rc {
            case 200, 201:
                if let id = userInfo["userId"] as? String,
                   let nickName = model.userName,
                   let image = model.userImg {
                    PloggingUserData.shared.saveUserData(id: id,
                                                         nickName: nickName,
                                                         image: image)
                }
                makeDefaultRootViewController()
                return
            case 409:
                setupErrorLabel(message: "이미 사용중인 닉네임입니다.")
                return
            default:
                print("error")
                return
            }
        } else if loginType == "SETTING" {
            switch model.rc {
            case 200:
                guard let nickName = nickNameTextField.text else { return }
                PloggingUserData.shared.setUserName(nickName: nickName)
                self.navigationController?.popViewController(animated: true)
                return
            case 409:
                setupErrorLabel(message: "이미 사용중인 닉네임입니다.")
                return
            default:
                print("error")
                return
            }
        } else {
            switch model.rc {
            case 201:
                makeLoginRootViewController()
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
    }
    
    
    @IBAction func clickConfirmButton(_ sender: UIButton) {
        guard let nickName = nickNameTextField.text else { return }
        if nickName.count > 0, nickName.count < 10 {
            // reqeust API
            requestUserSignUp()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension NickNameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let count = textField.text?.count {
            print(count)
            if count > 9 {
                setupErrorLabel(message: "공백포함 9자까지")
                return
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nickNameInfoLabel.isHidden = true
        if let count = textField.text?.count {
            if count > 0, count < 10 {
                confirmButton.backgroundColor = UIColor.tintGreen
            } else {
                confirmButton.backgroundColor = UIColor.loginGray
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            nickNameInfoLabel.isHidden = false
        }
    }
}
