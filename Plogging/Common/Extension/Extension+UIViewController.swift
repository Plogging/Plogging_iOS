//
//  Extension+UIViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/06.
//

import UIKit

extension UIViewController {
    var rootViewController: UIViewController? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
    }
}

extension UIViewController {
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "SNSLogin", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "SNSLoginViewController") as? SNSLoginViewController {
            loginViewController.modalPresentationStyle = .formSheet
            loginViewController.isModalInPresentation = true
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
}
