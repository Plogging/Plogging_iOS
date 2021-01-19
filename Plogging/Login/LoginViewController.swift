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
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupUI() {
        emailView.clipsToBounds = true
        emailView.layer.cornerRadius = 4
        
        passwordView.clipsToBounds = true
        passwordView.layer.cornerRadius = 4
        
        signInButton.clipsToBounds = true
        signInButton.layer.cornerRadius = 12
    }
    
    @IBAction func ClickedFindPasswordButton(_ sender: UIButton) {
        
    }
    
}
