//
//  MyPageViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/13.
//

import UIKit
import Kingfisher

enum MyPageSortType {
    case date
    case score
    case trashCount
    
    var description: String {
        switch self {
        case .date:
            return "최신순"
        case .score:
            return "점수순"
        case .trashCount:
            return "모은 쓰레기 순"
        }
    }
    
    func getDataSource() -> PagingDataSource<PloggingList> {
        switch self {
        case .date:
            return PagingDataSource<PloggingList>(api: PagingAPI(url: BaseURL.mainURL + BasePath.ploggingResult, params: ["searchType" : 0, "ploggingCntPerPage" : 10], header: APICollection.sharedAPI.gettingHeader()), type: .mypage)
        case .score:
            return PagingDataSource<PloggingList>(api: PagingAPI(url: BaseURL.mainURL + BasePath.ploggingResult, params: ["searchType" : 1, "ploggingCntPerPage" : 10], header: APICollection.sharedAPI.gettingHeader()), type: .mypage)
        case .trashCount:
            return PagingDataSource<PloggingList>(api: PagingAPI(url: BaseURL.mainURL + BasePath.ploggingResult, params: ["searchType" : 2, "ploggingCntPerPage" : 10], header: APICollection.sharedAPI.gettingHeader()), type: .mypage)
        }
    }
}

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
    @IBOutlet weak var sortingLabel: UILabel!
    @IBOutlet weak var sortingButton: UIButton!
    private let scrollDownNavigationViewHeight = 269
    private let scrollUpNavigationBarViewHeight = 82
    private let thresholdOffset = 70
    private(set) var currentSortType: MyPageSortType = .date {
        didSet {
            currentPagingDataSource = currentSortType.getDataSource()
        }
    }
    private(set) var currentPagingDataSource: PagingDataSource<PloggingList>? = MyPageSortType.date.getDataSource()
    
    var type = DetailType.mypage

    enum DetailType {
        case ranking
        case mypage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == SegueIdentifier.showPloggingDetailInfo {
            guard let ploggingDetailInfoViewController = segue.destination as? PloggingDetailInfoViewController else {
                return
            }
            if let indexPath = sender as? Int {
                let ploggingList = currentPagingDataSource?.contents[indexPath]
                ploggingDetailInfoViewController.ploggingList = ploggingList
                ploggingDetailInfoViewController.profileImage = profilePhoto.image
                ploggingDetailInfoViewController.userName = nickName.text
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarUI()
        scrollView.addGestureRecognizer(collectionView.panGestureRecognizer)
        
        currentPagingDataSource?.loadFromFirst {
            self.updateUI()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteItem), name: Notification.Name.deleteItem, object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let userId = PloggingUserData.shared.getUserId() else {
            return
        }
        
        APICollection.sharedAPI.requestUserInfo(id: userId) { [weak self] response in
            if let result = try? response.get() {
                if result.rc == 200 {
                    print("success")
                    self?.nickName.text = result.userName
                    guard let ploggingImageUrl = URL(string: result.userImg) else {
                        return
                    }
                    self?.profilePhoto.kf.setImage(with: ploggingImageUrl)
                    self?.totalPloggingDistance.text = "\(result.distanceMonthly)km"
                    self?.totalPloggingScore.text = "\(result.scoreMonthly)점"
                    self?.totalTrashCount.text = "\(result.trashMonthly)개"
                    
                } else if result.rc == 401 {
                    //로그인 화면으로 전환
                }
            }
        }
    }
    
    func mypageTabReload() {
        currentSortType = .date
        currentPagingDataSource?.loadFromFirst {
            self.updateUI()
        }
    }
  
    func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
//            self.refreshControl.endRefreshing()
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
    
    @objc func deleteItem(_ notification: Notification) {
        currentPagingDataSource?.loadFromFirst {
            self.updateUI()
        }
    }
    
    @IBAction func goToSetting(_ sender: Any) {
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        
        guard let settingViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController else {
            return
        }
        settingViewController.profileImage = profilePhoto.image
        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    @IBAction func sortingPloggingContents(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let dateSorting = UIAlertAction(title: "최신순", style: .default) { [weak self] _ in
            self?.currentSortType = .date
            self?.currentPagingDataSource?.loadFromFirst {
                self?.updateUI()
            }
            self?.sortingLabel.text = self?.currentSortType.description
        }
        let scoreSorting = UIAlertAction(title: "점수순", style: .default) { [weak self] _ in
            self?.currentSortType = .score
            self?.currentPagingDataSource?.loadFromFirst {
                self?.updateUI()
            }
            self?.sortingLabel.text = self?.currentSortType.description
        }
        let trashCountSorting = UIAlertAction(title: "모은 쓰레기 순", style: .default) { [weak self] _ in
            self?.currentSortType = .trashCount
            self?.currentPagingDataSource?.loadFromFirst {
                self?.updateUI()
            }
            self?.sortingLabel.text = self?.currentSortType.description
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(dateSorting)
        alert.addAction(scoreSorting)
        alert.addAction(trashCountSorting)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDataSource
extension MyPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let currentPagingDataSource = currentPagingDataSource else {
            return 0
        }
        return currentPagingDataSource.contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PloggingResultPhotoCell", for: indexPath)
        let ploggingResultPhotoCell = cell as? PloggingResultPhotoCell
    
        guard let currentPagingDataSource = currentPagingDataSource, indexPath.item < currentPagingDataSource.contents.count else {
            return cell
        }
        
        // TODO: 페이징 테스트용 지우기
        guard let ploggingImageUrl = currentPagingDataSource.contents[indexPath.item].meta.ploggingImage else {
            return cell
        }
        
        guard let createdTime = currentPagingDataSource.contents[indexPath.item].meta.createdTime else {
            return cell
        }
        
        guard let ploggingTotalScore = currentPagingDataSource.contents[indexPath.item].meta.ploggingTotalScore else {
            return cell
        }
        
        guard let ploggingTrashCount = currentPagingDataSource.contents[indexPath.item].meta.ploggingTrashCount else {
            return cell
        }
        
        
        guard let url = URL(string: ploggingImageUrl) else {
            return cell
        }
        
        ploggingResultPhotoCell?.updateUI(ploggingImageUrl: url, time: createdTime, scroe: ploggingTotalScore, trash: ploggingTrashCount)

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
        
        if scrollView.requestNextPage() {
            currentPagingDataSource?.loadNext {
                self.updateUI()
            }
        }
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

extension UIScrollView {
    func requestNextPage(minimumBottomValue: CGFloat = 50) -> Bool {
        let offsetMaxY = contentOffset.y + bounds.height
        return contentSize.height - offsetMaxY < minimumBottomValue
    }
}
