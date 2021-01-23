//
//  PloggingViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/13.
//

import UIKit

class PloggingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clickStartPloggingButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboard.WaitingScreen.rawValue, bundle: nil)
        if let waitingScreenViewController = storyboard.instantiateViewController(withIdentifier: "WaitingScreenViewController") as? WaitingScreenViewController {
            waitingScreenViewController.modalPresentationStyle = .fullScreen
            self.present(waitingScreenViewController, animated: false, completion: nil)
        }
    }
}
