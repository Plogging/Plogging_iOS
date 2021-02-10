//
//  ChangePasswordViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/02/09.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action:#selector(self.handlePopGesture))
    }
    
    @objc func handlePopGesture(gesture: UIGestureRecognizer) -> Void {
        if gesture.state == UIGestureRecognizer.State.began {
            (rootViewController as? MainViewController)?.setTabBarHidden(true)
        }
    }
    
    @IBAction func completeChangePassword(_ sender: Any) {
        showPopUpViewController(with: .비밀번호변경완료팝업)
    }
}
