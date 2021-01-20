//
//  PopUpViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/21.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var popUpOuterView: UIView!
    @IBOutlet weak var popUpInnerView: UIView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
   
    private func setupUI() {
        popUpInnerView.clipsToBounds = true
        popUpInnerView.layer.cornerRadius = 12
        
        yesButton.clipsToBounds = true
        yesButton.layer.cornerRadius = 12
        noButton.clipsToBounds = true
        noButton.layer.cornerRadius = 12
    }
    
    @IBAction func clickNoButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func clickYesButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
