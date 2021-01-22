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
        
        let alert = UIAlertController(title: "플로깅 종료하기", message: "플로깅을 종료하시겠습니까?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "아니오", style: .default) { _ in
        }
        let no = UIAlertAction(title: "네", style: .default) { _ in
            self.dismiss(animated: false, completion: {
                let ploggingResult = UIStoryboard(name: "PloggingResult", bundle: nil)
                let ploggingResultViewController = ploggingResult.instantiateViewController(identifier: "PloggingResultViewController")
                ploggingResultViewController.modalPresentationStyle = .fullScreen
                ploggingResultViewController.modalTransitionStyle = .crossDissolve
                self.rootViewController?.present(ploggingResultViewController, animated: false, completion: nil)
            })
        }
        alert.addAction(yes)
        alert.addAction(no)
        present(alert, animated: true, completion: nil)
    }
}
