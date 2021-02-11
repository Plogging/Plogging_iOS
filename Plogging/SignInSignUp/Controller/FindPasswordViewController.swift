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
    
    @IBAction func clickConfirmButton(_ sender: UIButton) {
        guard let email = emailTextField.text else {
            return
        }

        // reqeust API
        let param: [String: Any] = ["email": email]
        
        APICollection.sharedAPI.requestUserPasswordTemp(param: param) { (response) in
            let result = try? response.get()
            print(result)
        }
        
        // success
        self.performSegue(withIdentifier: SegueIdentifier.passwordCompletionViewController, sender: nil)
    }
}
