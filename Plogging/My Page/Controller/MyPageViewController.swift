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
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var totalPloggingScore: UILabel!
    @IBOutlet weak var totalPloggingDistance: UILabel!
    @IBOutlet weak var totalTrashCount: UILabel!
    
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

    @IBAction func sortingPloggingContents(_ sender: UIButton) {
        let alert = UIAlertController(title: "플로깅 기록 정렬하기", message: "플로깅 기록의 정렬방식을 선택하세요.", preferredStyle: .actionSheet)
        let dateSorting = UIAlertAction(title: "최신순", style: .default) { _ in
           
        }
        let trashCountSorting = UIAlertAction(title: "모은 쓰레기 순", style: .default) { _ in
            
        }
        
        let scoreSorting = UIAlertAction(title: "점수순", style: .default) { _ in
            
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(dateSorting)
        alert.addAction(trashCountSorting)
        alert.addAction(scoreSorting)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 8
        let width = (collectionView.bounds.width - itemSpacing) / 2
        let height = width + itemSpacing
        return CGSize(width: width, height: height)
    }
}
