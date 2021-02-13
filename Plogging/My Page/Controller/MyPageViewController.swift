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
    private let scrollDownNavigationViewHeight = 269
    private let scrollUpNavigationBarViewHeight = 82
    private let thresholdOffset = 70
    private var ploggingInfo: PloggingInfo? {
        didSet {
            checkValidation()
        }
    }
    private let dataSource = PloggingDataSource<PloggingList>(api: PagingAPI(url: BaseURL.mainURL + BasePath.ploggingResult, params: ["searchType" : 0], header: APICollection.sharedAPI.gettingHeader()))
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == SegueIdentifier.showPloggingDetailInfo {
            guard let ploggingDetailInfoViewController = segue.destination as? PloggingDetailInfoViewController else {
                return
            }
            if let indexPath = sender as? Int {
               //상세 페이지로 서버 결과 전달
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarUI()
        scrollView.addGestureRecognizer(collectionView.panGestureRecognizer)
        
//        let requestPloggingData = APICollection.sharedAPI.requestGetPloggingResult(param: [:]) { (response) in
//            self.ploggingInfo = try? response.get()
//        }
        dataSource.loadFromFirst {
            self.updateUI()
        }
    }
    
    func updateUI() {
        collectionView.reloadData()
    }
    
    private func checkValidation() {
        guard let model = ploggingInfo else {
            return
        }
        switch model.rc {
        case 200:
            print("success!!")
        case 401:
            print("권한없음. 로그인 필요")
            //로그인 페이지로 전환
        case 500:
            print("서버 error")
        default:
            print("success")
        }
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
        
        guard let settingViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController else {
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
        return dataSource.contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PloggingResultPhotoCell", for: indexPath)
        let ploggingResultPhotoCell = cell as? PloggingResultPhotoCell
       
        guard indexPath.item < dataSource.contents.count else {
            return cell
        }
        let content = dataSource.contents[indexPath.item]
        
        ploggingResultPhotoCell?.updateUI(image: UIImage(named: "test")!)
        
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension MyPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        performSegue(withIdentifier: SegueIdentifier.showPloggingDetailInfo, sender: indexPath.item)
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
        let startEdgeInsets = CGFloat(191)
        
        return UIEdgeInsets(top: startEdgeInsets, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - UIScrollViewDelegate
extension MyPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffSetY = scrollView.contentOffset.y
        navigationBarView.transform = CGAffineTransform(translationX: 0, y: -contentOffSetY)
        print("contentOffSetY: \(contentOffSetY)")
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
        if velocity.y >= 0, contentOffSetY > CGFloat(thresholdOffset) { // 올릴 때
            navigationBarViewHeight.constant = CGFloat(scrollUpNavigationBarViewHeight)
        } else if velocity.y < 0, contentOffSetY <= CGFloat(thresholdOffset) { // 내릴 때
                navigationBarView.transform = CGAffineTransform(translationX: 0, y: 0)
                navigationBarViewHeight.constant = CGFloat(scrollDownNavigationViewHeight)
        }
        navigationBarView.layoutIfNeeded()
    }
}
