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
    func setGradationView(view: UIView, colors:[CGColor], location: Double, startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = [NSNumber(value: location)]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75,
                                               y: self.view.frame.size.height-100,
                                               width: 150,
                                               height: 35)
        )
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UIViewController {
    func setNavigationBarClear() {
        if let navigationBar: UINavigationBar = self.navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.backgroundColor = UIColor.clear
            navigationController?.navigationBar.barTintColor = .black
            navigationController?.navigationBar.tintColor = .black
        }
    }
    
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: Storyboard.SNSLogin.rawValue, bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "SNSLoginViewController") as? SNSLoginViewController {
            loginViewController.modalPresentationStyle = .fullScreen
            loginViewController.isModalInPresentation = true
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
  
    func showPopUpViewController(with type: PopUpType) {
        let storyboard = UIStoryboard(name: Storyboard.PopUp.rawValue, bundle: nil)
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
    
    func showPloggingViewController() {
        let storyboard = UIStoryboard(name: Storyboard.PloggingMain.rawValue, bundle: nil)
        if let ploggingStartViewControl = storyboard.instantiateViewController(withIdentifier: "PloggingStartViewController") as? PloggingStartViewController {
            ploggingStartViewControl.modalPresentationStyle = .fullScreen
            self.present(ploggingStartViewControl, animated: true, completion: nil)
        }
    }
    
    func makeDefaultRootViewController() {
        let storyboard = UIStoryboard(name: Storyboard.Main.rawValue, bundle: nil)
        if let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController,
           let first = UIApplication.shared.windows.first {
            
            first.rootViewController = mainViewController
            first.makeKeyAndVisible()
            UIView.transition(with: first,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
    
    func makeLoginRootViewController() {
        let storyboard = UIStoryboard(name: Storyboard.SNSLogin.rawValue, bundle: nil)
    
        if let mainViewController = storyboard.instantiateViewController(withIdentifier: "SNSLoginViewController") as? SNSLoginViewController,
           let first = UIApplication.shared.windows.first {
            let navigationController = UINavigationController()
            navigationController.pushViewController(mainViewController, animated: false)
            
            first.rootViewController = navigationController
            first.makeKeyAndVisible()
            UIView.transition(with: first,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}
