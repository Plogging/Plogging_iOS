//
//  DeleteUserViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/02/09.
//

import UIKit

class DeleteUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarClear()

        self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action:#selector(self.handlePopGesture))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func handlePopGesture(gesture: UIGestureRecognizer) -> Void {
        if gesture.state == UIGestureRecognizer.State.began {
            (rootViewController as? MainViewController)?.setTabBarHidden(true)
        }
    }
    
    @IBAction func agreeSignOut(_ sender: Any) {
        APICollection.sharedAPI.requestDeleteUser { (response) in
            if let result = try? response.get() {
                if result.rc == 200 {
                    PloggingUserData.shared.removeAppleUserData()
                    PloggingCookie.shared.removeUserCookie()
                    PloggingUserData.shared.removeUserData()
                    self.makeLoginRootViewController()
                } else {
                    print(result.rcmsg)
                }
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
