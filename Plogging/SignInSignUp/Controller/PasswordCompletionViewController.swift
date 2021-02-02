//
//  PasswordCompletionViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/03.
//

import UIKit

class PasswordCompletionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
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
    }
    
    @IBAction func clickConfirmButton(_ sender: UIButton) {
        
    }
}
