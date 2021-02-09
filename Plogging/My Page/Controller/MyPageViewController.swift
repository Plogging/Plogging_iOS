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
    @IBOutlet weak var fixHeaderView: UIView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var sortingView: UIStackView!
    @IBOutlet weak var sortingButton: UIButton!
    let scrollDownNavigationViewHeight = 269
    let scrollUpNavigationBarViewHeight = 82
    let thresholdOffset = 70
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showPloggingDetailInfo" {
            guard let ploggingDetailInfoViewController = segue.destination as? PloggingDetailInfoViewController else {
                return
            }
            if let indexPath = sender as? Int {
               //서버 결과 전달
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarUI()
        scrollView.addGestureRecognizer(collectionView.panGestureRecognizer)
    }
    
    func setUpNavigationBarUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        fixHeaderView.backgroundColor = UIColor.tintGreen
        setGradationView(view: navigationBarView, colors: [UIColor.tintGreen.cgColor, UIColor.lightGreenishBlue.cgColor], location: 0.5, startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0))
        
        navigationBarView.clipsToBounds = true
        navigationBarView.layer.cornerRadius = 37
        navigationBarView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    
    @IBAction func goToSetting(_ sender: Any) {
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        
        guard let settingViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") else {
            return
        }
        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    @IBAction func sortingPloggingContents(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
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
        
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension MyPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        performSegue(withIdentifier: "showPloggingDetailInfo", sender: indexPath.item)
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
        return UIEdgeInsets(top: 191, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - UIScrollViewDelegate
extension MyPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffSetY = scrollView.contentOffset.y
        navigationBarView.transform = CGAffineTransform(translationX: 0, y: -contentOffSetY)
        
        if contentOffSetY > CGFloat(thresholdOffset) {
            navigationBarView.transform = CGAffineTransform(translationX: 0, y: 0)
            UIView.animate(withDuration: 0.05, animations: { [self] () -> Void in
                navigationBarViewHeight.constant = CGFloat(scrollUpNavigationBarViewHeight)
                nickName.transform = CGAffineTransform(translationX: 40, y: -46)
                nickName.font = nickName.font.withSize(26)
                nickName.transform = CGAffineTransform(translationX: 40, y: -46)
                
                let scaledAndTranslatedTransform = CGAffineTransform(translationX: 15, y: -40).scaledBy(x: 0.6, y: 0.6)
                profilePhoto.transform = scaledAndTranslatedTransform
            })
        } else if contentOffSetY <= CGFloat(thresholdOffset) {
            navigationBarView.transform = CGAffineTransform(translationX: 0, y: 0)
            navigationBarViewHeight.constant = CGFloat(scrollDownNavigationViewHeight)
            nickName.transform = CGAffineTransform(translationX: 0, y: 0)
            nickName.font = nickName.font.withSize(35)
            
            profilePhoto.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        navigationBarView.layoutIfNeeded()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let contentOffSetY = scrollView.contentOffset.y
        if velocity.y > CGFloat(thresholdOffset) { // 올릴 때
            navigationBarViewHeight.constant = CGFloat(scrollUpNavigationBarViewHeight)
        } else { // 내릴 때
            if contentOffSetY <= CGFloat(thresholdOffset) {
                navigationBarView.transform = CGAffineTransform(translationX: 0, y: 0)
                navigationBarViewHeight.constant = CGFloat(scrollDownNavigationViewHeight)
            }
        }
        navigationBarView.layoutIfNeeded()
    }
}
