//
//  SignUpViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/18.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNotification()
        setupUI()
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
    
    func setupUI() {
        emailView.clipsToBounds = true
        emailView.layer.cornerRadius = 4
        
        passwordView.clipsToBounds = true
        passwordView.layer.cornerRadius = 4
        
        signUpButton.clipsToBounds = true
        signUpButton.layer.cornerRadius = 12
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if signUpButtonBottomConstraint.constant == 36,
           let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            signUpButtonBottomConstraint.constant = keyboardHeight + 6
            
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        signUpButtonBottomConstraint.constant = 36
        
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
