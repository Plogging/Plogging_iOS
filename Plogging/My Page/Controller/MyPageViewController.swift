//
//  MyPageViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/13.
//

import UIKit
import Kingfisher

enum DetailType {
    case ranking
    case mypage
}

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
    
    func getDataSource(url: String) -> PagingDataSource<PloggingList> {
        switch self {
        case .date:
            return PagingDataSource<PloggingList>(api: PagingAPI(url: url, params: ["searchType" : 0, "ploggingCntPerPage" : 30], header: APICollection.sharedAPI.gettingHeader()), type: .mypage)
        case .score:
            return PagingDataSource<PloggingList>(api: PagingAPI(url: url, params: ["searchType" : 1, "ploggingCntPerPage" : 30], header: APICollection.sharedAPI.gettingHeader()), type: .mypage)
        case .trashCount:
            return PagingDataSource<PloggingList>(api: PagingAPI(url: url, params: ["searchType" : 2, "ploggingCntPerPage" : 30], header: APICollection.sharedAPI.gettingHeader()), type: .mypage)
        }
    }
}

class MyPageViewController: UIViewController {
    @IBOutlet weak var navigationBarButton: UIButton!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var shortNavigationBarView: UIView!
    @IBOutlet weak var shortNavigationBarProfilePhoto: UIImageView!
    @IBOutlet weak var shortNavigationBarNickName: UILabel!
    @IBOutlet weak var shortNavigationBarButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalPloggingScore: UILabel!
    @IBOutlet weak var totalPloggingDistance: UILabel!
    @IBOutlet weak var totalTrashCount: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navigationBarViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fixHeaderView: UIView!
    @IBOutlet weak var sortingView: UIStackView!
    @IBOutlet weak var sortingLabel: UILabel!
    @IBOutlet weak var sortingButton: UIButton!
    @IBOutlet weak var ploggingInfoView: UIView!
    private let scrollDownNavigationViewHeight = 269
    private let scrollUpNavigationBarViewHeight = 82
    private let thresholdOffset = 70
    private var contentsOffset = 0
    private var footerSizeHeight = 0
    private var url = BaseURL.getURL(basePath: .ploggingResult(PloggingUserData.shared.getUserId() ?? ""))
    private(set) var currentSortType: MyPageSortType = .date {
        didSet {
            currentPagingDataSource = currentSortType.getDataSource(url: url)
        }
    }
    private(set) var currentPagingDataSource: PagingDataSource<PloggingList>? = MyPageSortType.date.getDataSource(url: BaseURL.getURL(basePath: .ploggingResult(PloggingUserData.shared.getUserId() ?? "")))
    var userId = PloggingUserData.shared.getUserId() ?? "" {
        didSet {
            url = BaseURL.getURL(basePath: .ploggingResult(userId))
            currentPagingDataSource = MyPageSortType.date.getDataSource(url: url)
        }
    }
    var weeklyOrMonthly = ""
    var type = DetailType.mypage
    
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
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        currentPagingDataSource?.loadFromFirst {
            self.updateUI()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteItem), name: Notification.Name.deleteItem, object: nil)
        
        navigationBarButton.addTarget(self, action: #selector(goToSetting), for: .touchUpInside)
        shortNavigationBarButton.addTarget(self, action: #selector(goToSetting), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        requestHeaderData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setUpNavigationBarUI() {
        if type == .mypage {
            navigationBarButton.setImage(UIImage(named: "setting"), for: .normal)
            navigationBarButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            shortNavigationBarButton.setImage(UIImage(named: "setting"), for: .normal)
        } else {
            navigationBarButton.setImage(UIImage(named: "buttonBack"), for: .normal)
            navigationBarButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            shortNavigationBarButton.setImage(UIImage(named: "buttonBack"), for: .normal)
            shortNavigationBarButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            shortNavigationBarNickName.leadingAnchor.constraint(equalTo: shortNavigationBarButton.trailingAnchor, constant: -5).isActive = true
        }
        fixHeaderView.backgroundColor = UIColor.tintGreen
        navigationBarView.backgroundColor = UIColor.tintGreen
        shortNavigationBarView.backgroundColor = UIColor.tintGreen
        
        shortNavigationBarButton.alpha = 0
        shortNavigationBarNickName.alpha = 0
        shortNavigationBarProfilePhoto.alpha = 0
        
        navigationBarView.clipsToBounds = true
        navigationBarView.layer.cornerRadius = 37
        navigationBarView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        
        shortNavigationBarView.clipsToBounds = true
        shortNavigationBarView.layer.cornerRadius = 37
        shortNavigationBarView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    
    private func requestHeaderData() {
        APICollection.sharedAPI.requestUserInfo(id: userId) { [weak self] (response) in
            let userData = try? response.get()
            if userData?.rc != 200 {
                // 쿠키가 유효하지 않음
//                self.makeLoginRootViewController()
                return
            } else {
                self?.nickName.text = userData?.userName
                self?.shortNavigationBarNickName.text = userData?.userName
                if let userImage = userData?.userImg,
                   let userImageURL = URL(string: userImage) {
                    if self?.type == .mypage {
                        PloggingUserData.shared.setUserImage(userImageUrl: userImage)
                    }
                    self?.profilePhoto.sizeToFit()
                    self?.profilePhoto.kf.setImage(with: userImageURL, placeholder: UIImage(named: "user"))
                    self?.shortNavigationBarProfilePhoto.kf.setImage(with: userImageURL, placeholder: UIImage(named: "user"))
                }
                
                if self?.weeklyOrMonthly == "weekly" {
                    self?.totalPloggingScore.text = "\(userData?.scoreWeekly ?? 0)점"
                    self?.totalPloggingDistance.text = String(format: "%.2f", Float(userData?.distanceWeekly ?? 0)/1000) + "km"
                    self?.totalTrashCount.text = "\(userData?.trashWeekly ?? 0)개"
                } else {
                    self?.totalPloggingScore.text = "\(userData?.scoreMonthly ?? 0)점"
                    self?.totalPloggingDistance.text = String(format: "%.2f", Float(userData?.distanceMonthly ?? 0)/1000) + "km"
                    self?.totalTrashCount.text = "\(userData?.trashMonthly ?? 0)개"
                }
            }
        }
    }
    
    func mypageTabReload() {
        requestHeaderData()
        currentSortType = .date
        currentPagingDataSource?.loadFromFirst {
            self.updateUI()
        }
    }

    private func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc func deleteItem(_ notification: Notification) {
        currentPagingDataSource?.loadFromFirst {
            self.updateUI()
        }
    }
    
    @objc func goToSetting() {
        if type == .mypage {
            (rootViewController as? MainViewController)?.setTabBarHidden(true)
            guard let settingViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController else {
                return
            }
            navigationController?.pushViewController(settingViewController, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
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
        
        guard let ploggingImageUrl = currentPagingDataSource.contents[indexPath.item].meta.ploggingImage else {
            return cell
        }
        
        guard let url = URL(string: ploggingImageUrl) else {
            return cell
        }
        
        ploggingResultPhotoCell?.updateUI(ploggingImageUrl: url)

        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension MyPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        if type == .mypage {
            performSegue(withIdentifier: SegueIdentifier.showPloggingDetailInfo, sender: indexPath.item)
        } else {
            let storyboard = UIStoryboard(name: Storyboard.Ranking.rawValue, bundle: nil)
            if let photoViewController = storyboard.instantiateViewController(identifier: "RankingPhotoViewController") as? RankingPhotoViewController {
                photoViewController.modalPresentationStyle = .fullScreen
                photoViewController.image = currentPagingDataSource?.contents[indexPath.item].meta.ploggingImage
                self.present(photoViewController, animated: false, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        var footerSize = CGSize()
        
        if collectionView.numberOfItems(inSection: 0) < 1 {
            return CGSize(width: 0, height: 0)
        }
        
        guard let tabBarBottomCoverViewHeight = (rootViewController as? MainViewController)?.tabBarBottomCoverView.bounds.height else {
            return CGSize(width: 0, height: 0)
        }
        
        guard let tabBarHeight = (rootViewController as? MainViewController)?.tabBar.bounds.height else {
            return CGSize(width: 0, height: 0)
        }
        
        let leading = 24
        let trailing = 24
        let lineSpacing = 10
        let topSpacing = 160
        var contentsLineCount = 1
        
        if collectionView.numberOfItems(inSection: 0) > 2, collectionView.numberOfItems(inSection: 0) <= 4 {
            contentsLineCount = 2
        } else if collectionView.numberOfItems(inSection: 0) > 4 {
            contentsLineCount = 3
        }
        
        let contentsSize = (((Int(DeviceInfo.screenWidth) - leading - trailing - lineSpacing) / 2) * contentsLineCount)
        
        var footerHeight = Int(DeviceInfo.screenHeight - fixHeaderView.bounds.height) - topSpacing
                        - contentsSize - (10 * (contentsLineCount - 1)) - Int(tabBarBottomCoverViewHeight)
        if footerHeight < 0 {
            footerHeight += Int(tabBarHeight) + lineSpacing * 3
        }
        
        footerSize = CGSize(width: 0, height: footerHeight)
        
        return footerSize
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
        let startEdgeInsets = CGFloat(185)
        
        return UIEdgeInsets(top: startEdgeInsets, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - UIScrollViewDelegate
extension MyPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffSetY = scrollView.contentOffset.y
        navigationBarView.transform = CGAffineTransform(translationX: 0, y: min(0, -contentOffSetY))
        let maxContentOffSetY = CGFloat(183)
        let navigationBarButtonThresholds = CGFloat(20)
        let navigationBarItemsThresholds = CGFloat(40)
        let ploggingInfoViewThresholds = CGFloat(160)
        
        if contentOffSetY < maxContentOffSetY {
            sortingView.transform = CGAffineTransform(translationX: 0, y: -contentOffSetY)
            sortingButton.transform = CGAffineTransform(translationX: 0, y: -contentOffSetY)
        } else {
            sortingView.transform = CGAffineTransform(translationX: 0, y: -maxContentOffSetY)
            sortingButton.transform = CGAffineTransform(translationX: 0, y: -maxContentOffSetY)
        }

        if contentOffSetY > navigationBarButtonThresholds {
            UIView.animate(withDuration: 0.1, animations: { [weak self] () -> Void in
                self?.navigationBarButton.alpha = 0
            })
        } else if contentOffSetY <= navigationBarButtonThresholds {
            navigationBarButton.alpha = 1
        }
        
        if contentOffSetY > navigationBarItemsThresholds {
            UIView.animate(withDuration: 0.1, animations: { [weak self] () -> Void in
                self?.nickName.alpha = 0
                self?.profilePhoto.alpha = 0
            })
        } else if contentOffSetY <= navigationBarItemsThresholds {
            nickName.alpha = 1
            profilePhoto.alpha = 1
        }
        
        if contentOffSetY > ploggingInfoViewThresholds {
            UIView.animate(withDuration: 0.1, animations: { [weak self] () -> Void in
                self?.ploggingInfoView.alpha = 0
            })
        } else if contentOffSetY <= ploggingInfoViewThresholds {
            UIView.animate(withDuration: 0.1, animations: { [weak self] () -> Void in
                self?.ploggingInfoView.alpha = 1
            })
        }
        
        if contentOffSetY > maxContentOffSetY {
            navigationBarView.alpha = 0
            UIView.animate(withDuration: 0.2, animations: { [weak self] () -> Void in
                self?.shortNavigationBarButton.alpha = 1
                self?.shortNavigationBarNickName.alpha = 1
                self?.shortNavigationBarProfilePhoto.alpha = 1
            })
        } else if contentOffSetY <= maxContentOffSetY {
            navigationBarView.alpha = 1
            UIView.animate(withDuration: 0.2, animations: { [weak self] () -> Void in
                self?.shortNavigationBarButton.alpha = 0
                self?.shortNavigationBarNickName.alpha = 0
                self?.shortNavigationBarProfilePhoto.alpha = 0
            })
        }
        
        navigationBarView.layoutIfNeeded()

        if scrollView.requestNextPage() {
            currentPagingDataSource?.loadNext {
                self.updateUI()
            }
        }
    }
}

extension UIScrollView {
    func requestNextPage(minimumBottomValue: CGFloat = 50) -> Bool {
        let offsetMaxY = contentOffset.y + bounds.height
        return contentSize.height - offsetMaxY < minimumBottomValue
    }
}
