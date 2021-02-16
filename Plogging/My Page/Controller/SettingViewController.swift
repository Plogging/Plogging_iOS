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
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarUI()
        imagePickerController.delegate = self
        profilePhotoCoverView.alpha = 0
        checkImage.alpha = 0
        profilePhoto.image = profileImage
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
}

// MARK: IBAction
extension SettingViewController {
    // 뒤로가기 버튼
    @IBAction func back(_ sender: Any) {
        (rootViewController as? MainViewController)?.setTabBarHidden(false)
        self.navigationController?.popViewController(animated: true)
    }
    
    // 프로필 변경
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
    
    // 닉네임 변경
    @IBAction func changeNickName(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SNSLogin", bundle: nil)
        if let nickNameViewController = storyboard.instantiateViewController(withIdentifier: "NickNameViewController") as? NickNameViewController {
            nickNameViewController.myNickName = nickName.text ?? ""
            self.navigationController?.pushViewController(nickNameViewController, animated: true)
        }
    }
    
    // 비밀번호 변경
    @IBAction func changePassword(_ sender: Any) {
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        guard let changePasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController else {
            return
        }
        navigationController?.pushViewController(changePasswordViewController, animated: true)
    }
    
    // 로그아웃
    @IBAction func logout(_ sender: Any) {
        showPopUpViewController(with: .로그아웃팝업)
    }
    
    // 회원탈퇴
    @IBAction func signOut(_ sender: Any) {
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        guard let deleteUserViewController = self.storyboard?.instantiateViewController(withIdentifier: "DeleteUserViewController") as? DeleteUserViewController else {
            return
        }
        navigationController?.pushViewController(deleteUserViewController, animated: true)
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
