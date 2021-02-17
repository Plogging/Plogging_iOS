//
// Created by KHU_TAEWOO on 2021/01/29.
//

import Foundation
import UIKit
import MapKit

class PloggingRunningInfoViewController: UIViewController {

    @IBOutlet weak var summeryStackView: UIStackView!
    @IBOutlet weak var summeryDistance: SummeryItem!
    @IBOutlet weak var summeryTime: SummeryItem!
    @IBOutlet weak var summeryKcal: SummeryItem!
    @IBOutlet weak var continueButton: ConfirmButton!
    @IBOutlet weak var stopButton: ConfirmButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var countLabel: UILabel!
    
    var timer: Timer?
    var startDate: Date?
    var distance: Int?

    // todo: remove it
    public var count: Int = 0

    var currentTrashList: [TrashItem] = [
        TrashItem(trashType: .vinyl, pickCount: 0),
        TrashItem(trashType: .can, pickCount: 0),
        TrashItem(trashType: .extra, pickCount: 0),
        TrashItem(trashType: .glass, pickCount: 0),
        TrashItem(trashType: .paper, pickCount: 0),
        TrashItem(trashType: .plastic, pickCount: 0),
    ]
    
    var pathManager = PathManager.pathManager

    var ploggingActivityScore: Int?
    var ploggingEnvironmentScore: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSummeryDataUpdate()
        startUpdate()
    }
    
    
    func updateCount() {
        countLabel.text = "\(count)"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case SegueIdentifier.pickTrash: do {
                if let destination = segue.destination as? PloggingPickTrashViewController {
                    destination.trashItemList = currentTrashList.sorted { first, second in
                        first.trashType.rawValue < second.trashType.rawValue
                    }
                }
            }
            default:
                break
            }


        }
    }

    /// MARK: mockup
    func createPloggingResult() -> PloggingResult {
        
        let ploggingResult = PloggingResult (
                distance: self.distance,
                calories: 250,
                ploggingTime: Int(timer?.fireDate.timeIntervalSince(startDate ?? Date()) ?? 0),
                trashList: currentTrashList
        )

        return ploggingResult
    }

    private func getParam() -> [String : Any] {
        let ploggingTime = Int(timer?.fireDate.timeIntervalSince(startDate ?? Date()) ?? 0)
        
        var calorie = 0
        if calorie == 0 {
            calorie = 1
        }

        var distance = self.distance ?? 0
        if distance == 0 {
            distance = 1
        }
        
        let meta: [String : Any] = [
            "distance" : distance,
            "calorie" : calorie,
            "plogging_time" : ploggingTime
        ]
        
        var trashListArray: [[String : Any]] = []
        
        let trashCount = currentTrashList.count
        
        var trashType = 0
        var pickCount = 0
        
        var trashList: [String : Any] = [
            "trash_type" : trashType,
            "pick_count" : pickCount
        ]
        
        for i in 0 ..< trashCount {
            trashType = currentTrashList[i].trashType.rawValue
            pickCount = currentTrashList[i].pickCount
            
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
    
    @IBAction func finishPlogging() {
        APICollection.sharedAPI.requestPloggingScore(param: getParam()) { [weak self] (response) in
            guard let self = self else {
                return
            }
            if let result = try? response.get() {
                if result.rc == 200 {
                    self.ploggingActivityScore = result.score.activityScore
                    self.ploggingEnvironmentScore = result.score.environmentScore
                    
                } else if result.rc == 401 {
                    self.makeLoginRootViewController()
                }
            }
        }
        
        let storyboard = UIStoryboard(name: Storyboard.PopUp.rawValue, bundle: nil)
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            popUpViewController.type = .종료팝업
            popUpViewController.ploggingStopAction =  { [weak self] in
                self?.pathManager.stopRunning()
                self?.dismiss(animated: false, completion: { [weak self] in
                    let ploggingResult = UIStoryboard(name: Storyboard.PloggingResult.rawValue, bundle: nil)
                    guard let ploggingResultViewController = ploggingResult.instantiateViewController(withIdentifier: "PloggingResultViewController") as? PloggingResultViewController else {
                        return
                    }
                    ploggingResultViewController.ploggingResult = self?.createPloggingResult()
                    let ploggingResultNavigationController = UINavigationController(rootViewController: ploggingResultViewController)
                    ploggingResultViewController.ploggingActivityScore = self?.ploggingActivityScore
                    ploggingResultViewController.ploggingEnvironmentScore = self?.ploggingEnvironmentScore
                    ploggingResultViewController.requestParameter = self?.getParam() ?? [:]
                    ploggingResultNavigationController.modalPresentationStyle = .fullScreen
                    ploggingResultNavigationController.modalTransitionStyle = .crossDissolve
                    self?.rootViewController?.present(ploggingResultNavigationController, animated: false, completion: nil)
                })
            }
            popUpViewController.modalPresentationStyle = .overCurrentContext
            self.present(popUpViewController, animated: false, completion: nil)
        }
    }

    func setupSummeryDataUpdate() {

        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveDistanceNotification(_:)),
                name: Notification.Name("UpdateDistance"), object: nil)

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            guard let startDate = self.startDate else {return}
            let interval = timer.fireDate.timeIntervalSince(startDate)
            let minute = String(format: "%02d",(Int(interval) / 60))
            let second = String(format: "%02d",(Int(interval) % 60))
            DispatchQueue.main.async {
                self.summeryTime.dataLabel.text = "\(minute):\(second)"
            }
        }
    }


    func setupView() {
        summeryDistance.setupView(unit: "킬로미터", value: "0.00")
        summeryTime.setupView(unit: "분", value: "00:00")
        summeryKcal.setupView(unit: "kcal", value: "0")
        stopButton.backgroundColor = .gray
        stopButton.setTitle("종료", for: .normal)
        
        continueButton.setTitle("쓰레기 기록하기", for: .normal)
        
        summeryStackView.layer.cornerRadius = 20
        summeryStackView.backgroundColor = .clear
        
        pathManager.setupMapview(on: mapView)
        pathManager.startRunning()
    }

    func startUpdate() {
        startDate = Date()
        timer?.fire()
    }

    
    func addGradation(to: UIView) {
        let gradation = CAGradientLayer()
        gradation.colors = [
            UIColor.fromInt(red: 255, green: 255, blue: 255, alpha: 0.75).cgColor,
            UIColor.fromInt(red: 255, green: 255, blue: 255, alpha: 1).cgColor
        ]
        gradation.frame = to.bounds
        
        to.layer.addSublayer(gradation)
    }

    @objc func didReceiveDistanceNotification(_ receive: Notification) {
        guard let distance = receive.userInfo?["distance"] as? Int else { return }
        self.distance = distance
        DispatchQueue.main.async {
            self.summeryDistance.dataLabel.text = String(format: "%.2f", Float(distance)/1000)
        }
    }
}
