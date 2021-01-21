//
//  Extension+UIViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/06.
//

import UIKit

extension UIViewController {
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "SNSLogin", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "SNSLoginViewController") as? SNSLoginViewController {
            loginViewController.modalPresentationStyle = .formSheet
            loginViewController.isModalInPresentation = true
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
    
    func showWaitingScreenViewController() {
        let storyboard = UIStoryboard(name: "WaitingScreen", bundle: nil)
        if let waitingScreenViewController = storyboard.instantiateViewController(withIdentifier: "WaitingScreenViewController") as? WaitingScreenViewController {
            waitingScreenViewController.modalPresentationStyle = .fullScreen
            self.present(waitingScreenViewController, animated: false, completion: nil)
        }
    }
}
