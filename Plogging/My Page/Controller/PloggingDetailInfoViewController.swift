//
//  PloggingDetailInfoViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/02/08.
//

import UIKit

class PloggingDetailInfoViewController: UIViewController {
    @IBOutlet weak var fixHeaderView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarUI()
        self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action:#selector(self.handlePopGesture))
    }
    
    func setUpNavigationBarUI() {
        fixHeaderView.backgroundColor = UIColor.tintGreen
        navigationBarView.backgroundColor = UIColor.tintGreen
//        setGradationView(view: navigationBarView, colors: [UIColor.tintGreen.cgColor, UIColor.lightGreenishBlue.cgColor], location: 0.5, startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0))
        setGradationView(view: footerView, colors: [UIColor.paleGrey.cgColor, UIColor.paleGreyZero.cgColor], location: 0.5, startPoint: CGPoint(x: 0.5, y: 1.0), endPoint: CGPoint(x: 0.5, y: 0.0))
        
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
    
    @IBAction func managePloggingRecord(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let savePloggingPhoto = UIAlertAction(title: "사진 저장", style: .default) { _ in
            UIImageWriteToSavedPhotosAlbum(UIImage() /*서버 연결 후 수정*/, nil, nil, nil)
        }
        let deletePloggingRecord = UIAlertAction(title: "기록 삭제", style: .default) { _ in
            // 네트워크 플로깅 기록 삭제 추가
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(savePloggingPhoto)
        alert.addAction(deletePloggingRecord)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sharePloggingPhoto(_ sender: Any) {
        
    }
}
