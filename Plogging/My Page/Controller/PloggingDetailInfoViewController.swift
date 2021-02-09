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
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var ploggingDate: UILabel!
    @IBOutlet weak var ploggingTatalScore: UILabel!
    @IBOutlet weak var ploggingDistance: UILabel!
    @IBOutlet weak var ploggingTime: UILabel!
    @IBOutlet weak var totalTrashCountTitle: UILabel!
    @IBOutlet weak var totalTrashCount: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var trashInfoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    var ploggingResultData: PloggingList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ploggingResultData = createPloggingResultData()
        collectionView.reloadData()
        
        setUpNavigationBarUI()
        setUpTrashInfoViewUI()
        setUpFooterViewUI()
        
        self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action:#selector(self.handlePopGesture))
    }
    
    func createPloggingResultData() -> PloggingList {
        let meta = Meta(userId: nil, createTime: nil, distance: 5, calories: 250, ploggingTime: 7, ploggingImage: nil, ploggingTotalScore: nil, ploggingActivityScore: nil, ploggingEnvironmentScore: nil)
        let trashList = [TrashList(trashType: 1, pickCount: 5), TrashList(trashType: 3, pickCount: 4)]
        
        let ploggingList = PloggingList(id: nil, meta: meta, trashList: trashList)
    
        return ploggingList
    }
    
    private func setUpNavigationBarUI() {
        fixHeaderView.backgroundColor = UIColor.tintGreen
        navigationBarView.backgroundColor = UIColor.tintGreen
        
        navigationBarView.clipsToBounds = true
        navigationBarView.layer.cornerRadius = 37
        navigationBarView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    
    private func setUpTrashInfoViewUI() {
        guard let trashInfos = ploggingResultData?.trashList else {
            return
        }
        
        let trashInfosCount = trashInfos.count
        
        contentViewHeight.constant = 1150 /* contentView Height */ + CGFloat((50 * trashInfosCount))
        trashInfoViewHeight.constant = 80 /* totalCountView height */ + 40 /* top constraint */+ CGFloat((50 * trashInfosCount))
        
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
    
    @IBAction func back(_ sender: Any) {
        (rootViewController as? MainViewController)?.setTabBarHidden(false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func managePloggingRecord(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let savePloggingPhoto = UIAlertAction(title: "사진 저장", style: .default) { [self] _ in
            
//            guard let ploggingImageUrlString = self?.ploggingResultData?.meta.ploggingImage else {
//                return
//            }
//            guard let url = URL(string: ploggingImageUrlString) else {
//                return
//            }
//            var ploggingImage : UIImage?
//            if let data = try? Data(contentsOf: url) {
//                ploggingImage = UIImage(data: data)
//                UIImageWriteToSavedPhotosAlbum(ploggingImage ?? UIImage() /*서버 연결 후 수정*/, nil, nil, nil)
//            }
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
        guard let url = URL(string: "instagram-stories://share") else { return }
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Instagram is not installed")
            }
        }
        
    }
}

// MARK: UICollectionViewDataSource
extension PloggingDetailInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let trashInfos = ploggingResultData?.trashList else {
            return 0
        }
        return trashInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrashCountCell", for: indexPath)
        let trashCountCell = cell as? TrashCountCell

        guard let trashInfos = ploggingResultData?.trashList else {
            return cell
        }
        
        guard indexPath.item < trashInfos.count else {
            return cell
        }
       
        trashCountCell?.updateUI(trashInfos[indexPath.item])
        
        let isLastItem = indexPath.item == trashInfos.count - 1
        if isLastItem {
            trashCountCell?.changeSeparatorColor()
        }
 
        if trashInfos.getTrashPickTotalCount() == 0 {
            //쓰레기 0개일 때 처리 추가 
//            trashCountCell?.pickUpZero()
        }
    
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PloggingDetailInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leading = 54
        let trailing = 54
        
        return CGSize(width: Int(DeviceInfo.screenWidth) - leading - trailing , height: 50)
    }
}