//
//  LoginViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var ploggingUserInfo: PloggingUser? {
        didSet {
            checkAPIResponse()
        }
    }
    private var isValidate: Bool = false {
        didSet {
            if isValidate {
                signInButton.backgroundColor = UIColor.tintGreen
            } else {
                signInButton.backgroundColor = UIColor.loginGray
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupDelegate()
        setupNotification()
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
        emailView.clipsToBounds = true
        emailView.layer.cornerRadius = 4
        
        passwordView.clipsToBounds = true
        passwordView.layer.cornerRadius = 4
        passwordTextField.isSecureTextEntry = true
        
        signInButton.clipsToBounds = true
        signInButton.layer.cornerRadius = 12
    }
    
    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @IBAction func clickedFindPasswordButton(_ sender: UIButton) {

    }
    
    @IBAction func clickConfirmButton(_ sender: UIButton) {
        if isValidate {
            guard let email = emailTextField.text,
                  let password = passwordTextField.text else {
                return
            }

            let param: [String: Any] = [
                "userId": email,
                "secretKey": password
            ]
            
            APICollection.sharedAPI.requestSignInCustom(param: param) { (response) in
                self.ploggingUserInfo = try? response.get()
                if let code = try? response.get().rc {
                    if code == 404, let message = try? response.get().rcmsg {
                        self.showToast(message: message)
                    }
                }
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    private func checkAPIResponse() {
        guard let model = ploggingUserInfo else {
            return
        }
        switch model.rc {
        case 200:
            if let id = emailTextField.text, let nickName = model.userName, let image = model.userImg {
                PloggingUserData.shared.saveUserData(id: "\(id):custom",
                                                     nickName: nickName,
                                                     image: image)
            }
            makeDefaultRootViewController()
            return
        case 401:
            setupWarningLabel(message: "가입되지 않은 정보이거나 비밀번호가 다릅니다.")
            return
        default:
            print("error")
            return
        }
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
    
    @IBAction func clickedKakaoLoginButton(_ sender: UIButton) {
        SNSLoginManager.shared.setupLoginWithKakao()
        SNSLoginManager.shared.requestLoginWithKakao { (loginData) in
            print(loginData)
        }
    }
    
    @IBAction func clickedNaverLoginButton(_ sender: UIButton) {
        SNSLoginManager.shared.setupLoginWithNaver()
        SNSLoginManager.shared.requestLoginWithNaver { (loginData) in
            print(loginData)
        }
    }

    @IBAction func clickedAppleLoginButton(_ sender: UIButton) {
        SNSLoginManager.shared.setupLoginWithApple()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .loginCompletion, object: nil)
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Any] {
            if let result = data["result"] as? PloggingUser,
               let userId = data["userId"] as? String {
                moveToOtherPage(result, userId)
            } else if let result = data["type"] as? String,
                      result == "apple" {
                // 애플로그인으로 들어오는 유저는 이 FLOW
                if let result = data["result"] as? PloggingUserInfo?,
                   let id = result?.userId,
                   let nickName = result?.userName,
                   let image = result?.userImg {
                    // 200 재로그인 유저
                    PloggingUserData.shared.saveUserData(id: id,
                                                         nickName: nickName,
                                                         image: image)
                    makeDefaultRootViewController()
                } else {
                    // 200외 다른 RC는 회원탈퇴로 간주하고 애플로그인 재설정 요청
                    showPopUpViewController(with: .애플로그인재설정)
                }
            }
        }
    }
    
    func moveToOtherPage(_ result: PloggingUser, _ id: String) {
        switch result.rc {
        case 200, 201:
            if let nickName = result.userName, let image = result.userImg {
                if nickName.count > 9 {
                    let storyboard = UIStoryboard(name: Storyboard.SNSLogin.rawValue, bundle: nil)
                    if let viewcontroller = storyboard.instantiateViewController(identifier: SegueIdentifier.nickNameViewController) as? NickNameViewController {
                        viewcontroller.loginType = "SNS"
                        viewcontroller.userInfo = ["userId": id]
                        self.navigationController?.pushViewController(viewcontroller, animated: true)
                    }
                } else {
                    PloggingUserData.shared.saveUserData(id: id,
                                                         nickName: nickName,
                                                         image: image)
                }
            }
            let storyboard = UIStoryboard(name: Storyboard.SNSLogin.rawValue, bundle: nil)
            if let viewcontroller = storyboard.instantiateViewController(identifier: SegueIdentifier.nickNameViewController) as? NickNameViewController {
                viewcontroller.loginType = "SNS"
                viewcontroller.userInfo = ["userId": id]
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            }
            return
        default:
            print("error")
            setupWarningLabel(message: result.rcmsg)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 이메일 체크
        if let email = emailTextField.text {
            if let message = checkEmailVaidation(email: email) {
                setupWarningLabel(message: message)
                return
            }
            setupWarningLabel(message: nil)
        }
        
        // 비밀번호
        if let password = passwordTextField.text, password.count > 1 {
            setupWarningLabel(message: nil)
        }
        
        isValidate = true
    }
}

extension LoginViewController: LoginValidation {}
