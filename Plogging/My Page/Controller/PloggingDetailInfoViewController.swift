//
//  PloggingDetailInfoViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/02/08.
//

import UIKit
import Photos
import Kingfisher

extension Notification.Name {
    static let deleteItem = Notification.Name("deleteItem")
}

class PloggingDetailInfoViewController: UIViewController {
    @IBOutlet weak var fixHeaderView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var ploggingDate: UILabel!
    @IBOutlet weak var ploggingImageView: UIImageView!
    @IBOutlet weak var ploggingTatalScore: UILabel!
    @IBOutlet weak var ploggingDistance: UILabel!
    @IBOutlet weak var ploggingTime: UILabel!
    @IBOutlet weak var totalTrashCountTitle: UILabel!
    @IBOutlet weak var totalTrashCount: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var trashInfoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    private let contentViewOriginalHeight = 1150
    private let totalCountViewOriginalHeight = 80
    private let trashInfoViewTopConstraint = 40
    private let collectionViewCellLeading = 54
    private let collectionViewCellTrailing = 54
    var ploggingList: PloggingList?
    var profileImage: UIImage?
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
        
        setUpNavigationBarUI()
        setUpTrashInfoViewUI()
        setUpFooterViewUI()
        
        self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action:#selector(self.handlePopGesture))
    }

    private func setUpNavigationBarUI() {
        fixHeaderView.backgroundColor = UIColor.tintGreen
        navigationBarView.backgroundColor = UIColor.tintGreen
        
        navigationBarView.clipsToBounds = true
        navigationBarView.layer.cornerRadius = 37
        navigationBarView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    
    private func setUpTrashInfoViewUI() {
        guard let trashInfos = ploggingList?.trashList else {
            return
        }
        let trashInfosCount = trashInfos.count
        
        profilePhoto.image = profileImage
        nickName.text = userName
        
        guard let createdTime = ploggingList?.meta.createdTime else {
            return
        }
        let yearEndIdx: String.Index = createdTime.index(createdTime.startIndex, offsetBy: 3)
        let year = String(createdTime[...yearEndIdx])

        let monthStart = createdTime.index(createdTime.startIndex, offsetBy: 4)
        let monthEnd = createdTime.index(createdTime.endIndex, offsetBy: -9)
        let month = String(createdTime[monthStart...monthEnd])
    
        let dayStart = createdTime.index(createdTime.startIndex, offsetBy: 6)
        let dayEnd = createdTime.index(createdTime.endIndex, offsetBy: -7)
        let day = String(createdTime[dayStart...dayEnd])
        ploggingDate.text = "\(year).\(month).\(day)"
        
        guard let ploggingImage =  ploggingList?.meta.ploggingImage, let ploggingImageURl = URL(string: ploggingImage) else {
            return
        }
        ploggingImageView.kf.setImage(with: ploggingImageURl)
        ploggingTatalScore.text = "\(ploggingList?.meta.ploggingTotalScore ?? 0)점"
        ploggingDistance.text = String(format: "%.2f", Float(ploggingList?.meta.distance ?? 0)/1000)
        let minute = String(format: "%02d",(ploggingList?.meta.ploggingTime ?? 0) / 60)
        let second = String(format: "%02d",(ploggingList?.meta.ploggingTime ?? 0) % 60)
        ploggingTime.text = "\(minute):\(second)"
        
        contentViewHeight.constant = CGFloat(contentViewOriginalHeight) + CGFloat((50 * trashInfosCount))
        trashInfoViewHeight.constant = CGFloat(totalCountViewOriginalHeight + trashInfoViewTopConstraint) + CGFloat((50 * trashInfosCount))
        
        let trashCountSum = trashInfos.getTrashPickTotalCount()
        totalTrashCount.text = "\(trashCountSum)개"
        totalTrashCountTitle.text = "총 \(trashCountSum)개의 쓰레기를 주웠어요!"
    }
    
    private func setUpFooterViewUI() {
        setGradationView(view: footerView, colors: [UIColor.paleGrey.cgColor, UIColor.paleGreyZero.cgColor], location: 0.5, startPoint: CGPoint(x: 0.5, y: 1.0), endPoint: CGPoint(x: 0.5, y: 0.0))
    }
    
    @objc func handlePopGesture(gesture: UIGestureRecognizer) -> Void {
        if gesture.state == UIGestureRecognizer.State.began {
            (rootViewController as? MainViewController)?.setTabBarHidden(false)
        }
    }
    
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

// MARK: IBAction
extension PloggingDetailInfoViewController {
    @IBAction func back(_ sender: Any) {
        (rootViewController as? MainViewController)?.setTabBarHidden(false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePloggingRecord(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "기록 삭제", style: .default) { [weak self] _ in
            guard let ploggingImage =  self?.ploggingList?.meta.ploggingImage else {
                return
            }
            guard let ploggingId = self?.ploggingList?.id else {
                return
            }
            
            APICollection.sharedAPI.deletePloggingRecord(id: ploggingId, ploggingImaegName: ploggingImage) { [weak self] (response) in
                if let result = try? response.get() {
                    if result.rc == 200 {
                        NotificationCenter.default.post(name: Notification.Name.deleteItem, object: nil)
                        (self?.rootViewController as? MainViewController)?.setTabBarHidden(false)
                        self?.navigationController?.popViewController(animated: true)
                    } else if result.rc == 401 {
                        self?.showLoginViewController()
                    }
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sharePloggingPhoto(_ sender: Any) {
        guard let ploggingImge = ploggingImageView.image else {
            return
        }
        
        let storyboard = UIStoryboard(name: Storyboard.PopUp.rawValue, bundle: nil)
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            popUpViewController.type = .사진저장승인
            popUpViewController.savePhotoAction =  { [weak self] in
                UIImageWriteToSavedPhotosAlbum(ploggingImge, self, #selector(self?.shareToInstagram(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            popUpViewController.modalPresentationStyle = .overCurrentContext
            self.present(popUpViewController, animated: false, completion: nil)
        }
    }
}

// MARK: UICollectionViewDataSource
extension PloggingDetailInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let trashInfos = ploggingList?.trashList else {
            return 0
        }
        return trashInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrashCountCell", for: indexPath)
        let trashCountCell = cell as? TrashCountCell
        
        guard let trashInfos = ploggingList?.trashList else {
            return cell
        }
        
        guard indexPath.item < trashInfos.count else {
            return cell
        }
        
        trashCountCell?.trash = trashInfos[indexPath.item]
        
        let isLastItem = indexPath.item == trashInfos.count - 1
        if isLastItem {
            trashCountCell?.changeSeparatorColor()
        }
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PloggingDetailInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Int(DeviceInfo.screenWidth) - collectionViewCellLeading - collectionViewCellTrailing , height: 50)
    }
}
