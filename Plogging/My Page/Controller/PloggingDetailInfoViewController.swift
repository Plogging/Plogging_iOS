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
    let tabBarState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarUI()
    }
    
    func setUpNavigationBarUI() {
        fixHeaderView.backgroundColor = UIColor.tintGreen
        navigationBarView.backgroundColor = UIColor.tintGreen
//        setGradationView(view: navigationBarView, colors: [UIColor.tintGreen.cgColor, UIColor.lightGreenishBlue.cgColor], location: 0.5, startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0))
        
        navigationBarView.clipsToBounds = true
        navigationBarView.layer.cornerRadius = 37
        navigationBarView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
}
