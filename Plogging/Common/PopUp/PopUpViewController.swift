//
//  PopUpViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/21.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var popUpOuterView: UIView!
    @IBOutlet weak var popUpInnerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var outerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    var forwardingImage = UIImage()
    var ploggingResultParam: [String : Any] = [:]
    var ploggingDistance: Int?
    var ploggingTrashCount: Int?
    var shareImage: UIImage?
    var noPhotoSaveAction: (() -> Void)?
    var ploggingStopAction: (() -> Void)?
    var savePhotoAction: (() -> Void)?
    var dismissAction: (() -> Void)?
    
    var type: PopUpType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDefaultUI()
        setupPopUpTypeUI()
    }
   
    private func setupDefaultUI() {
        popUpInnerView.clipsToBounds = true
        popUpInnerView.layer.cornerRadius = 12
        yesButton.clipsToBounds = true
        yesButton.layer.cornerRadius = 12
        noButton.clipsToBounds = true
        noButton.layer.cornerRadius = 12
    }
    
    private func setupPopUpTypeUI() {
        guard let type = type else { return }
        
        titleLabel.text = type.titleMessage()
        descriptionLabel.text = type.descriptionMessage()
        imageView.image = type.image()
        
        outerViewHeightConstraint.constant = type.outerViewHeight()
        innerViewHeightConstraint.constant = type.innerViewHeight()
        imageTopConstraint.constant = type.topConstraint()
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: type.innerImageViewXConstraint()).isActive = true
        
        if type.numberOfButton() == 1 {
            noButton.isHidden = true
            yesButton.setTitle("확인", for: .normal)
        } else {
            noButton.isHidden = false
            yesButton.setTitle("네", for: .normal)
        }
        
        if type == .애플로그인재설정 {
            messageStackViewTopConstraint.constant = 30
        } else {
            messageStackViewTopConstraint.constant = 90
        }
    }
    
    @IBAction func clickNoButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func clickYesButton(_ sender: UIButton) {
        switch type {
        case .비밀번호변경완료팝업:
            PloggingCookie.shared.removeUserCookie()
            PloggingUserData.shared.removeUserData()
            makeLoginRootViewController()
        case .로그아웃팝업:
            APICollection.sharedAPI.requestUserSignOut { (response) in
                if let result = try? response.get() {
                    if result.rc == 200 {
                        // 로그인 화면으로 이동
                        PloggingCookie.shared.removeUserCookie()
                        PloggingUserData.shared.removeUserData()
                        self.makeLoginRootViewController()
                    } else {
                        print(result.rcmsg)
                    }
                }
            }
        case .기록삭제팝업:
            self.dismiss(animated: false, completion: nil)
            dismissAction?()
        case .사진없이저장팝업:
            self.dismiss(animated: false, completion: nil)
            noPhotoSaveAction?()
        case .사진저장승인:
            self.dismiss(animated: false, completion: nil)
            savePhotoAction?()
        case .종료팝업:
            self.dismiss(animated: false, completion: nil)
            ploggingStopAction?()
        default:
            print("")
        }
        
        self.dismiss(animated: false, completion: nil)
    }
}
