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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action:#selector(handlePopGesture))
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupUI() {
        nowPasswordOuterView.clipsToBounds = true
        changePasswordOuterView.clipsToBounds = true
        checkPasswordOuterView.clipsToBounds = true
        confirmButton.clipsToBounds = true
        
        nowPasswordOuterView.layer.cornerRadius = 4
        changePasswordOuterView.layer.cornerRadius = 4
        checkPasswordOuterView.layer.cornerRadius = 4
        confirmButton.layer.cornerRadius = 4
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
}
