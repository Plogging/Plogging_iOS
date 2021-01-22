//
//  Extension+UIViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/06.
//

import UIKit

enum Storyboard: String {
    case SNSLogin
    case Onboarding
}

extension UIViewController {
    var rootViewController: UIViewController? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
    }
}

extension UIViewController {
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: Storyboard.SNSLogin.rawValue, bundle: nil)
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
  
    func showPopUpViewController(with type: PopUpType) {
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            popUpViewController.type = type
            popUpViewController.modalPresentationStyle = .overCurrentContext
            self.present(popUpViewController, animated: false, completion: nil)
        }
    }
  
    func showOnboardingViewController() {
        let storyboard = UIStoryboard(name: Storyboard.Onboarding.rawValue, bundle: nil)
        if let onboardingViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as? OnboardingViewController {
            onboardingViewController.modalPresentationStyle = .fullScreen
            self.present(onboardingViewController, animated: true, completion: nil)
        }
    }
}
