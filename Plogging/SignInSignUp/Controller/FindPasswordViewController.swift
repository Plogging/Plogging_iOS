//
//  FindPasswordViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/31.
//

import UIKit

class FindPasswordViewController: UIViewController {

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
        // reqeust API
        
        // success
        self.performSegue(withIdentifier: SegueIdentifier.passwordCompletionViewController, sender: nil)
    }
}
