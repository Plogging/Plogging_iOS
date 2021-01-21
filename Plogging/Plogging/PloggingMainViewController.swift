//
//  PloggingMainViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/20.
//

import UIKit

class PloggingMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func moveToPloggingResult(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            let ploggingResult = UIStoryboard(name: "PloggingResult", bundle: nil)
            let ploggingResultViewController = ploggingResult.instantiateViewController(identifier: "PloggingResultViewController")
            ploggingResultViewController.modalPresentationStyle = .fullScreen
            ploggingResultViewController.modalTransitionStyle = .crossDissolve
            self.rootViewController?.present(ploggingResultViewController, animated: true, completion: nil)
        })
    }
}
