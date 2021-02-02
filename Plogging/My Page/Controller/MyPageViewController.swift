//
//  MyPageViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/13.
//

import UIKit

class MyPageViewController: UIViewController {
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    let itemSpacing: CGFloat = 8
    var width = 0
    var height = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarUI()
    }
    
    func setUpNavigationBarUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = navigationBarView.bounds
        
        let colors = [UIColor.tintGreen.cgColor, UIColor.lightGreenishBlue.cgColor]
        gradientLayer.colors = colors
         
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.5]

        navigationBarView.layer.addSublayer(gradientLayer)
        
        navigationBarView.clipsToBounds = true
        navigationBarView.layer.cornerRadius = 37
        navigationBarView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }

}

// MARK: UICollectionViewDataSource
//extension MyPageViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
//}

// MARK: UICollectionViewDelegate
extension MyPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
// MARK: UICollectionViewDelegateFlowLayout
extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    width = (collectionView.bounds.width - itemSpacing) / 2
    height = width * 10/7 + itemSpacing
    CGSize(width: width, height: height)
}
