//
//  PopUpViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/21.
//

import UIKit
import Photos

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
    var forwardingImage = UIImage()
    var ploggingResultParam: [String : Any] = [:]
    var ploggingDistance: Int?
    var ploggingTrashCount: Int?
    var shareImage: UIImage?
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
        case .비밀번호변경완료팝업:
            makeLoginRootViewController()
        case .로그아웃팝업:
            APICollection.sharedAPI.requestUserSignOut { (response) in
                if let result = try? response.get() {
                    if result.rc == 200 {
                        // 로그인 화면으로 이동
                        PloggingUserData.shared.removeUserData()
                        self.makeLoginRootViewController()
                    } else {
                        print(result.rcmsg)
                    }
                }
            }
        case .기록삭제팝업:
            break
        case .사진없이저장팝업:
            let ploggingResultImageMaker = PloggingResultImageMaker()
            guard let basicImage = UIImage(named: "basicImage") else {
                return
            }
            guard let distance = ploggingDistance, let trashCount = ploggingTrashCount else {
                return
            }
            
            let resizedBasicImage = basicImage.resize(targetSize: CGSize(width: DeviceInfo.screenWidth, height: DeviceInfo.screenWidth))
            let ploggingResultImage = ploggingResultImageMaker.createResultImage(baseImage: resizedBasicImage, distance: String(format: "%.2f", Float(distance ?? 0)/1000), trashCount: "\(trashCount)")
            forwardingImage = ploggingResultImage
            
            guard let forwardingImageData = forwardingImage.pngData() else {
                print("no forwardingImageData")
                return
            }
            
            APICollection.sharedAPI.requestRegisterPloggingResult(param: ploggingResultParam, imageData: forwardingImageData) { (response) in
                if let result = try? response.get() {
                    if result.rc == 200 {
                
                    } else if result.rc == 401 {
                        //로그인 화면으로 전환
                    }
                }
            }
        case .사진저장승인:
            guard let sharedImage = shareImage else {
                return
            }
            UIImageWriteToSavedPhotosAlbum(sharedImage, self, #selector(shareToInstagram(_:didFinishSavingWithError:contextInfo:)), nil)
        default:
            print("")
        }
        
        self.dismiss(animated: false, completion: nil)
        dismissAction?()
    }
}


// instagram 공유
extension PopUpViewController {
    @objc func shareToInstagram(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if let lastAsset = fetchResult.firstObject as? PHAsset {
            guard let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)") else {
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                showPopUpViewController(with: .인스타그램설치팝업)
            }
        }
    }
}
