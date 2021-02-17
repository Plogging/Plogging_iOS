//
//  PloggingResultViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/16.
//

import UIKit

class PloggingResultViewController: UIViewController {
    @IBOutlet weak var ploggingResultPhoto: UIImageView!
    @IBOutlet weak var totalTrashCount: UILabel!
    @IBOutlet weak var totalTrashCountTitle: UILabel!
    @IBOutlet weak var activityScore: UILabel!
    @IBOutlet weak var environmentScore: UILabel!
    @IBOutlet weak var ploggingDistance: UILabel!
    @IBOutlet weak var ploggingTime: UILabel!
    @IBOutlet weak var ploggingCalorie: UILabel!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var trashInfoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    private var ploggingActivityScore = 0
    private var ploggingEnvironmentScore = 0
    private let contentViewOriginalHeight = 1280
    private let totalCountViewOriginalHeight = 80
    private let trashInfoViewTopConstraint = 40
    private let collectionViewCellLeading = 54
    private let collectionViewCellTrailing = 54
    var baseImage: UIImage?
    var ploggingResult: PloggingResult?
    var forwardingImage = UIImage()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == SegueIdentifier.renderingAlbumPhoto {
            guard let PloggingResultPhotoViewController = segue.destination as? PloggingResultPhotoViewController else {
                return
            }
            PloggingResultPhotoViewController.baseImage = baseImage
            PloggingResultPhotoViewController.ploggingResult = ploggingResult
            PloggingResultPhotoViewController.trashCountSum = getTrashPickTotalCount()
        } else if segue.identifier == SegueIdentifier.openCamera {
            guard let cameraViewController = segue.destination as? CameraViewController else {
                return
            }
            cameraViewController.ploggingResult = ploggingResult
            cameraViewController.trashCountSum = getTrashPickTotalCount()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI(ploggingActivityScore: 0, ploggingEnvironmentScore: 0)
        
        APICollection.sharedAPI.requestPloggingScore(param: getParam()) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let result = try? response.get() {
                if result.rc == 200 {
                    print("success")
                    self.ploggingActivityScore = result.score.activityScore
                    self.ploggingEnvironmentScore = result.score.environmentScore
                    self.setUpUI(ploggingActivityScore: self.ploggingActivityScore, ploggingEnvironmentScore: self.ploggingEnvironmentScore)
                    
                } else if result.rc == 401 {
                    //로그인 화면으로 전환
                }
            }
        }
    }
    
    private func getParam() -> [String : Any] {
        guard let calorie = Int(ploggingCalorie.text ?? "0"),
              let ploggingTime = ploggingResult?.ploggingTime else {
            return [:]
        }
        
        var distance = ploggingResult?.distance ?? 0
        if distance == 0 {
            distance = 1
        }
        
        let meta: [String : Any] = [
            "distance" : distance,
            "calorie" : calorie,
            "plogging_time" : ploggingTime
        ]
        
        var trashListArray: [[String : Any]] = []
        
        guard let trashCount = ploggingResult?.trashList?.count else {
            return [:]
        }
        
        var trashType = 0
        var pickCount = 0
        
        var trashList: [String : Any] = [
            "trash_type" : trashType,
            "pick_count" : pickCount
        ]
        
        for i in 0 ..< trashCount {
            trashType = ploggingResult?.trashList?[i].trashType.rawValue ?? 0
            pickCount = ploggingResult?.trashList?[i].pickCount ?? 0
            
            if pickCount > 0 {
                trashList["trash_type"] = trashType
                trashList["pick_count"] = pickCount
                trashListArray.append(trashList)
            }
        }

        let param: [String : Any] = [
            "meta" : meta,
            "trash_list" : trashListArray
        ]
        return param
    }
    
    private func setUpUI(ploggingActivityScore: Int, ploggingEnvironmentScore: Int) {
        self.navigationController?.navigationBar.isHidden = true

        activityScore.text = "\(ploggingActivityScore)점"
        environmentScore.text = "\(ploggingEnvironmentScore)점"
        
        let minute = String(format: "%02d",(ploggingResult?.ploggingTime ?? 0) / 60)
        let second = String(format: "%02d",(ploggingResult?.ploggingTime ?? 0) % 60)
        ploggingTime.text = "\(minute):\(second)"
        ploggingDistance.text = String(format: "%.2f", Float(ploggingResult?.distance ?? 0)/1000)
        ploggingCalorie.text = String(ploggingResult?.calories ?? 0)
        
        totalTrashCount.text = "\(getTrashPickTotalCount())개"
        totalTrashCountTitle.text = "총 \(getTrashPickTotalCount())개의 쓰레기를 주웠어요!"

        let trashListCount = ploggingResult?.trashList?.count ?? 0

        contentViewHeight.constant = CGFloat(contentViewOriginalHeight) + CGFloat((50 * trashListCount))
        trashInfoViewHeight.constant = CGFloat(totalCountViewOriginalHeight + trashInfoViewTopConstraint) + CGFloat((50 * trashListCount))

        setGradationView(view: footerView, colors: [UIColor.paleGrey.cgColor, UIColor.paleGreyZero.cgColor], location: 0.5, startPoint: CGPoint(x: 0.5, y: 1.0), endPoint: CGPoint(x: 0.5, y: 0.0))
    }

    private func getTrashPickTotalCount() -> Int {
        guard let trashList = ploggingResult?.trashList else {
            return 0
        }

        let trashCountSum = trashList.getTrashPickTotalCount()
        return trashCountSum
    }

    private func showPloggingPhotoResisterAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) { [weak self] _ in
            self?.setUpImagePicker()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: SegueIdentifier.openCamera, sender: nil)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func setUpImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: IBAction
extension PloggingResultViewController {
    @IBAction func showScoreGuideAlert(_ sender: UIButton) {
        self.showPopUpViewController(with: .운동점수안내팝업)
    }
    
    @IBAction func registerPloggingPhoto(_ sender: UITapGestureRecognizer) {
        showPloggingPhotoResisterAlert()
    }
    
    @IBAction func savePloggingResult(_ sender: Any) {
        if ploggingResultPhoto.image == nil {
            let storyboard = UIStoryboard(name: Storyboard.PopUp.rawValue, bundle: nil)
            if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
                popUpViewController.type = .사진없이저장팝업
                popUpViewController.dismissAction =  { [weak self] in
                    self?.navigationController?.dismiss(animated: false, completion: nil)
                }
                popUpViewController.ploggingDistance = ploggingResult?.distance ?? 0
                popUpViewController.ploggingTrashCount = getTrashPickTotalCount()
                popUpViewController.ploggingResultParam = getParam()
                popUpViewController.modalPresentationStyle = .overCurrentContext
                self.present(popUpViewController, animated: false, completion: nil)
            }
        } else {
            guard let forwardingThumbnailImage = ploggingResultPhoto.image else {
                return
            }
            forwardingImage = forwardingThumbnailImage
        }

        guard let forwardingImageData = forwardingImage.pngData() else {
            print("no forwardingImageData")
            return
        }
        
        APICollection.sharedAPI.requestRegisterPloggingResult(param: getParam(), imageData: forwardingImageData) { [weak self] (response) in
            if let result = try? response.get() {
                if result.rc == 401 {
                    //로그인 페이지로 이동
                }
            }
        }
         navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deletePloggingResult(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboard.PopUp.rawValue, bundle: nil)
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            popUpViewController.type = .기록삭제팝업
            popUpViewController.dismissAction =  { [weak self] in
                self?.navigationController?.dismiss(animated: false, completion: nil)
            }
            popUpViewController.modalPresentationStyle = .overCurrentContext
            self.present(popUpViewController, animated: false, completion: nil)
        }
    }

    @IBAction func unwindToPloggingResult(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PloggingResultPhotoViewController, let thumbnailImage = sourceViewController.thumbnailImage {
            ploggingResultPhoto.image = thumbnailImage
        }
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PloggingResultViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        baseImage = selectedImage
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: SegueIdentifier.renderingAlbumPhoto, sender: nil)
    }
}

// MARK: UICollectionViewDataSource
extension PloggingResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let trashInfos = ploggingResult?.trashList else {
            return 0
        }
        return trashInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrashCountCell", for: indexPath)
        let trashCountCell = cell as? TrashCountCell

        guard let trashInfos = ploggingResult?.trashList, indexPath.item < trashInfos.count else {
            return cell
        }
        
        trashCountCell?.trash = trashInfos[indexPath.item]
        
        if indexPath.item == trashInfos.count - 1 {
            trashCountCell?.changeSeparatorColor()
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PloggingResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: Int(DeviceInfo.screenWidth) - collectionViewCellLeading - collectionViewCellTrailing , height: 50)
    }
}
