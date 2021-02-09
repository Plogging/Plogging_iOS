//
//  SettingViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/02/09.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var fixHeaderView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarUI()
        self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action:#selector(self.handlePopGesture))
    }
    
    private func setUpNavigationBarUI() {
        fixHeaderView.backgroundColor = UIColor.tintGreen
        navigationBarView.backgroundColor = UIColor.tintGreen
        
        navigationBarView.clipsToBounds = true
        navigationBarView.layer.cornerRadius = 37
        navigationBarView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    
    @objc func handlePopGesture(gesture: UIGestureRecognizer) -> Void {
        if gesture.state == UIGestureRecognizer.State.began {
            (rootViewController as? MainViewController)?.setTabBarHidden(false)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        (rootViewController as? MainViewController)?.setTabBarHidden(false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeProfilePhoto(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "카메라", style: .default) { _ in
            
        }
        let album = UIAlertAction(title: "앨범", style: .default) { _ in
            
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(camera)
        alert.addAction(album)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeNickName(_ sender: Any) {
        // 닉네임 변경 화면으로 push
    }
    
    @IBAction func changePassword(_ sender: Any) {
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        guard let changePasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController else {
            return
        }
        navigationController?.pushViewController(changePasswordViewController, animated: true)
        
    }
    
    @IBAction func logout(_ sender: Any) {
        showPopUpViewController(with: .로그아웃팝업)
    }
    
    @IBAction func signOut(_ sender: Any) {
        (rootViewController as? MainViewController)?.setTabBarHidden(false)
    }
    
}
