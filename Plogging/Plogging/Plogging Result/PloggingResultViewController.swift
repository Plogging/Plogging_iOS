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
    @IBOutlet weak var exerciseScore: UILabel!
    @IBOutlet weak var echoScore: UILabel!
    @IBOutlet weak var ploggingTime: UILabel!
    @IBOutlet weak var ploggingDistance: UILabel!
    @IBOutlet weak var ploggingCalorie: UILabel!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var trashInfoViewHeight: NSLayoutConstraint!
    var baseImage: UIImage?
    var ploggingResultData: PloggingResult?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == SegueIdentifier.renderingAlbumPhoto {
            guard let PloggingResultPhotoViewController = segue.destination as? PloggingResultPhotoViewController else {
                return
            }
            PloggingResultPhotoViewController.ploggingResultData = ploggingResultData
            PloggingResultPhotoViewController.baseImage = baseImage
        } else if segue.identifier == SegueIdentifier.openCamera {
            guard let cameraViewController = segue.destination as? CameraViewController else {
                return
            }
            cameraViewController.ploggingResultData = ploggingResultData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewUI()
    }
    
    private func setUpViewUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        let score = PloggingResult.Score(exercise: "\(500)", eco: "100")
        let info = PloggingResult.Info(time: "12:21", distance: "50", calorie: "990")
        let trashInfos = [PloggingResult.TrashInfo(name: "유리", count: "2"),PloggingResult.TrashInfo(name: "비닐", count: "5"),PloggingResult.TrashInfo(name: "그 외", count: "3")]
        let trashCountSum = PloggingResult.TrashCountSum(sum: "10")
        
        ploggingResultData = PloggingResult(score: score, info: info, trashInfos: trashInfos, trashCountSum: trashCountSum)
        
        contentViewHeight.constant = 1280 /* contentView Height */ + CGFloat((50 * getTrashInfosCount()))
        trashInfoViewHeight.constant = 80 /* totalCountView height */ + 40 /* top constraint */+ CGFloat((50 * getTrashInfosCount()))
        
        exerciseScore.text = ploggingResultData?.score.exercise
        echoScore.text = ploggingResultData?.score.eco
        ploggingTime.text = ploggingResultData?.info.time
        ploggingDistance.text = ploggingResultData?.info.distance
        ploggingCalorie.text = ploggingResultData?.info.calorie
        
        totalTrashCount.text = "\(getTrashCountSum())개"
        totalTrashCountTitle.text = "총 \(getTrashCountSum())개의 쓰레기를 주웠어요!"
    }
    
    public func getTrashCountSum() -> String {
        guard let trashCountSum = ploggingResultData?.trashCountSum.sum else {
            return ""
        }
        return trashCountSum
    }

    private func getTrashInfosCount() -> Int {
        guard let trashInfosCount = ploggingResultData?.trashInfos.count else {
            return 0
        }
        return trashInfosCount
    }
    
    private func showPloggingPhotoResisterAlert() {
        let alert = UIAlertController(title: "플로깅 사진 기록하기", message: "플로깅 사진 기록방식을 선택하세요.", preferredStyle: .actionSheet)
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
        if baseImage == nil {
            self.showPopUpViewController(with: .사진없이저장팝업)
            let ploggingResultImageMaker = PloggingResultImageMaker()
            guard let commonImage = UIImage(named: "test") else {
                return
            }
            guard let distance = ploggingResultData?.info.distance else {
                return
            }
            let ploggingResultImage = ploggingResultImageMaker.createResultImage(commonImage, distance, "\(getTrashCountSum())")
            ploggingResultPhoto.image = ploggingResultImage
            // self.navigationController?.dismiss(animated: true, completion: nil)
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
        guard let trashInfos = ploggingResultData?.trashInfos else {
            return 0
        }
        return trashInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrashCountCell", for: indexPath)
        let trashCountCell = cell as? TrashCountCell
        guard let trashInfos = ploggingResultData?.trashInfos else {
            return cell
        }
        trashCountCell?.updateUI(trashInfos[indexPath.item])
        
        if indexPath.item == trashInfos.count-1 {
            trashCountCell?.changeSeparatorColor()
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PloggingResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DeviceScreen.width - 108, height: 50)
    }
}
