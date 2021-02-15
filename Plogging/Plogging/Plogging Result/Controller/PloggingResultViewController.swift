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
    private var ploggingResultScore: PloggingResultScore? {
        didSet {
            checkScoreValidation()
        }
    }
    private var ploggingInfo: PloggingInfo? {
        didSet {
//            checkValidation()
        }
    }
    
    func getParam() -> [String: Any] {
        let meta: [String : Any] = [
            "distance" : 1000,
            "calorie" : 300,
            "plogging_time" : 5500
        ]
        
        var trashListArray: [[String : Any]] = []
        
        var trashList: [String : Any] = [
            "trash_type" : 1,
            "pick_count" : 4
        ]
        
        trashListArray.append(trashList)
        
        trashList = [
            "trash_type" : 2,
            "pick_count" : 4
        ]
        trashListArray.append(trashList)
        
        let param: [String: Any] = [
                "meta" : meta,
                "trash_list" : trashListArray
        ]
        
        return param
    }

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
        
        APICollection.sharedAPI.requestPloggingScore(param: getParam()) { [weak self] (response) in
            guard let self = self else {
                return
            }
            self.ploggingResultScore = try? response.get()
        }
    }
    
    private func checkScoreValidation() {
        guard let model = ploggingResultScore else {
            return
        }
        switch model.rc {
        case 200:
            print("success!!")
            ploggingActivityScore = model.score.activityScore
            ploggingEnvironmentScore = model.score.environmentScore
            self.setUpUI(ploggingActivityScore: ploggingActivityScore, ploggingEnvironmentScore: ploggingEnvironmentScore)
        case 401:
            print("권한없음. 로그인 필요")
            //로그인 페이지로 전환
        case 500:
            print("서버 error")
        default:
            print("success")
        }
    }
    
    
    private func setUpUI(ploggingActivityScore: Int, ploggingEnvironmentScore: Int) {
        self.navigationController?.navigationBar.isHidden = true

        activityScore.text = "\(ploggingActivityScore)점"
        environmentScore.text = "\(ploggingEnvironmentScore)점"
        
        ploggingTime.text = "\(ploggingResult?.ploggingTime ?? 0)"
        ploggingDistance.text = String(ploggingResult?.distance ?? 0)
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
        let library = UIAlertAction(title: "사진앨범", style: .default) { _ in
            self.setUpImagePicker()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { _ in
            self.performSegue(withIdentifier: SegueIdentifier.openCamera, sender: nil)
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
//            self.showPopUpViewController(with: .사진없이저장팝업)
            let ploggingResultImageMaker = PloggingResultImageMaker()
            guard let basicImage = UIImage(named: "basicImage") else {
                return
            }
            let resizedBasicImage = basicImage.resize(targetSize: CGSize(width: DeviceInfo.screenWidth, height: DeviceInfo.screenWidth))
            let ploggingResultImage = ploggingResultImageMaker.createResultImage(baseImage: resizedBasicImage, distance: "\(5.12)", trashCount: "\(getTrashPickTotalCount())")
            //서버 통신 추가
            ploggingResultPhoto.image = ploggingResultImage
            forwardingImage = ploggingResultImage
        } else {
            forwardingImage = ploggingResultPhoto.image!
        }

        guard let forwardingImageData = forwardingImage.pngData() else {
            print("no forwardingImageData")
            return
        }
    
        APICollection.sharedAPI.requestRegisterPloggingResult(param: getParam(), imageData: forwardingImageData) { (response) in
            self.ploggingInfo = try? response.get()
        }
        
         navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deletePloggingResult(_ sender: UIButton) {
        showPopUpViewController(with: .기록삭제팝업)
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

        trashCountCell?.updateUI(trashInfos[indexPath.item])
        
        if indexPath.item == trashInfos.count - 1 {
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
extension PloggingResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: Int(DeviceInfo.screenWidth) - collectionViewCellLeading - collectionViewCellTrailing , height: 50)
    }
}
