//
//  NickNameViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/31.
//

import UIKit

class NickNameViewController: UIViewController {

    @IBOutlet weak var nickNameInfoLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        confirmButton.clipsToBounds = true
        confirmButton.layer.cornerRadius = 12
    }

    @IBAction func clickConfirmButton(_ sender: UIButton) {
        
    }
}
