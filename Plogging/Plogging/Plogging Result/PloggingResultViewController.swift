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
            // 거리, 시간 추가 전달 필요
            PloggingResultPhotoViewController.baseImage = baseImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        let score = PloggingResult.Score(exercise: "\(500)", eco: "100")
        let info = PloggingResult.Info(time: "12:21", distance: "50", calorie: "990")
        let trashInfos = [PloggingResult.TrashInfo(name: "유리", count: "2"),PloggingResult.TrashInfo(name: "비닐", count: "5"),PloggingResult.TrashInfo(name: "그 외", count: "3")]
        
        ploggingResultData = PloggingResult(score: score, info: info, trashInfos: trashInfos)
        guard let trashInfosCount = ploggingResultData?.trashInfos.count else {
            return
        }
        
        contentViewHeight.constant = 1280 /* 전체 길이 */ + CGFloat((50 * trashInfosCount))
        trashInfoViewHeight.constant = 80 + 40 /* 윗 공간 */+ CGFloat((50 * trashInfosCount))
        
//        exerciseScore.text = ploggingResultData?.score.exercise
//        echoScore.text = ploggingResultData?.score.eco
//        ploggingTime.text = ploggingResultData?.info.time
//        ploggingDistance.text = ploggingResultData?.info.distance
//        ploggingCalorie.text = ploggingResultData?.info.calorie
        
        exerciseScore.text = "\(100)점"
        echoScore.text = "\(200)점"
        ploggingTime.text = "300"
        ploggingDistance.text = "400"
        ploggingCalorie.text = "500"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func showPloggingPhotoResisterAlert() {
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
    
    @IBAction func scoreGuideAlert(_ sender: UIButton) {
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
            let ploggingResultImage = ploggingResultImageMaker.createResultImage(commonImage, 2.13, "13:30")
            ploggingResultPhoto.image = ploggingResultImage
            // self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToPloggingResult(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PloggingResultPhotoViewController, let thumbnailImage = sourceViewController.thumbnailImage {
            ploggingResultPhoto.image = thumbnailImage
        }
    }
    
    private func setUpImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
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
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PloggingResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DeviceScreen.width - 108, height: 50)
    }
}
