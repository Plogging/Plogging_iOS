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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navigationBarViewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarUI()
        scrollView.addGestureRecognizer(collectionView.panGestureRecognizer)
    }
    
    func setUpNavigationBarUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = navigationBarView.bounds
        
        let colors = [UIColor.tintGreen.cgColor, UIColor.lightGreenishBlue.cgColor]
        gradientLayer.colors = colors
        
        gradientLayer.locations = [0.5]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        navigationBarView.layer.insertSublayer(gradientLayer, at:0)
        
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
extension MyPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PloggingResultPhotoCell", for: indexPath)
        let ploggingResultPhotoCell = cell as? PloggingResultPhotoCell
        guard let content = UIImage(named: "test") else {
            return cell
        }
        ploggingResultPhotoCell?.updateUI(image: content)
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension MyPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
// MARK: UICollectionViewDelegateFlowLayout
extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 10
        let width: CGFloat = (collectionView.bounds.width - itemSpacing)/2
        let height: CGFloat = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 170, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - UIScrollViewDelegate
extension MyPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.decelerationRate = .fast
        let contentOffSetY = scrollView.contentOffset.y
//        guard contentOffSetY > 0 else {
//            return
//        }
        if contentOffSetY > 0, contentOffSetY < 168 {
            navigationBarView.transform = CGAffineTransform(translationX: 0, y: -contentOffSetY)
            self.navigationBarView.layoutIfNeeded()
            print("0~168 contentOffSetY : \(contentOffSetY)")
        } else if contentOffSetY > 168 {
            navigationBarView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.navigationBarViewHeight.constant = 129
            self.navigationBarView.layoutIfNeeded()
            
        } else if contentOffSetY <= 0 {
//            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            navigationBarView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.navigationBarViewHeight.constant = 316
            self.navigationBarView.layoutIfNeeded()
        }
        print("contentOffSetY: \(contentOffSetY)")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("velocity: \(velocity.y)")
//        scrollView.decelerationRate = .fast
        let contentOffSetY = scrollView.contentOffset.y
        if velocity.y > 0 { // 올릴 때
            if contentOffSetY > 0, contentOffSetY < 168 {
                if contentOffSetY == 168 {
//                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
//                        self.navigationBarViewHeight.constant = 129
//                        self.navigationBarView.layoutIfNeeded()
//                    })
                }
//                navigationBarView.transform = CGAffineTransform(translationX: 0, y: -100)
//                navigationBarView.layoutIfNeeded()
                print("올릴 때contentOffSetY: \(contentOffSetY)")

//                UIView.animate(withDuration: 0.1, animations: { () -> Void in
//                    self.navigationBarViewHeight.constant = 129
//                    self.navigationBarView.layoutIfNeeded()
//                })
            }
        } else if contentOffSetY > 168 {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.navigationBarViewHeight.constant = 129
                self.navigationBarView.layoutIfNeeded()
            })
        } else {
            if contentOffSetY <= 0 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.navigationBarViewHeight.constant = 316
                    self.navigationBarView.layoutIfNeeded()
                    print("내릴 때 contentOffSetY: \(contentOffSetY)")
                })
            }
        }
    }
}
