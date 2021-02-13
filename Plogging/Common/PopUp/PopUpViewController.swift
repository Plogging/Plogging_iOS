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
        
        if type.numberOfButton() == 1 {
            noButton.isHidden = true
            yesButton.setTitle("확인", for: .normal)
        } else {
            noButton.isHidden = false
            yesButton.setTitle("네", for: .normal)
        }
    }
    
    @IBAction func clickNoButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func clickYesButton(_ sender: UIButton) {
        switch type {
        case .로그아웃팝업:
            APICollection.sharedAPI.requestUserSignOut { (response) in
                if let result = try? response.get() {
                    if result.rc == 200 {
                        // 로그인 화면으로 이동
                    } else {
                        print(result.rcmsg)
                    }
                }
            }
        default:
            print("")
        }
        
        self.dismiss(animated: false, completion: nil)
    }
}
