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
    @IBOutlet weak var profilePhotoCoverView: UIView!
    @IBOutlet weak var checkImage: UIImageView!
    let imagePickerController = UIImagePickerController()
    let checkImageView = UIImageView(image: UIImage(named: "check"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarUI()
        imagePickerController.delegate = self
        profilePhotoCoverView.alpha = 0
        checkImage.alpha = 0
        self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action:#selector(self.handlePopGesture))
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewDidLayoutSubviews() {
        
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
}

// MARK: IBAction
extension SettingViewController {
    @IBAction func back(_ sender: Any) {
        (rootViewController as? MainViewController)?.setTabBarHidden(false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeProfilePhoto(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "카메라", style: .default) { [self] _ in
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: false, completion: nil)
        }
        let album = UIAlertAction(title: "사진 앨범", style: .default) { [self] _ in
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: false, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(camera)
        alert.addAction(album)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeNickName(_ sender: Any) {
        // 닉네임 변경 화면으로 push
        let storyboard = UIStoryboard(name: "SNSLogin", bundle: nil)
        if let nickNameViewController = storyboard.instantiateViewController(withIdentifier: "NickNameViewController") as? NickNameViewController {
            self.navigationController?.pushViewController(nickNameViewController, animated: true)
        }
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
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        guard let signOutViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignOutViewController") as? SignOutViewController else {
            return
        }
        navigationController?.pushViewController(signOutViewController, animated: true)
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            profilePhoto.image = image
        }
        dismiss(animated: true, completion: nil)
        
        profilePhotoCoverView.alpha = 1
        checkImage.alpha = 1
        UIView.animate(withDuration: 0.8, animations: { [self] in
            profilePhotoCoverView.alpha = 0
            checkImage.alpha = 0
        })
    }
}
