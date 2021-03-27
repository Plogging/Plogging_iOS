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
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var currentLocationButton: UIButton!

    var timer: Timer?
    var startDate: Date?
    var distance: Int?
    var kcal: Int = 0

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
        countLabel.attributedText = NSMutableAttributedString().heavy("\(count)", fontSize: 72)
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

    func createPloggingResult() -> PloggingResult {
        let ploggingResult = PloggingResult(
                distance: self.distance,
                calories: self.kcal,
                ploggingTime: Int(timer?.fireDate.timeIntervalSince(startDate!) ?? 0),
                trashList: currentTrashList.filter{item in item.pickCount != 0}
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
//                    self.makeLoginRootViewController()
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
        summeryTime.setupView(unit: "진행시간", value: "00:00")
        summeryKcal.setupView(unit: "칼로리", value: "0")
        
        setGradationView(
            view: infoView,
            colors: [
                UIColor(red: 255, green: 255, blue: 255, alpha: 0.5).cgColor,
                UIColor(red: 255, green: 255, blue: 255, alpha: 1.0).cgColor
            ],
            location: 0.1,
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint: CGPoint(x: 0.5, y: 0.1)
        )
        infoView.layer.cornerRadius = 20
        infoView.clipsToBounds = true

        currentLocationButton.layer.cornerRadius = currentLocationButton.frame.height/2
        currentLocationButton.backgroundColor = .white
        
        stopButton.backgroundColor = UIColor.veryLightPinkTwo
        stopButton.setAttributedTitle(NSMutableAttributedString().normal("종료", fontSize: 19), for: .normal)
        stopButton.setTitleColor(.brownGrey, for: .normal)

        continueButton.title = "쓰레기 기록하기"
        continueButton.layer.shadowColor = UIColor.tintGreen.cgColor
        continueButton.layer.shadowOpacity = 0.67
        continueButton.layer.shadowOffset = .init(width: 0, height: 4)

        pathManager.setupMapview(on: mapView)
        pathManager.startRunning()
    }

    func startUpdate() {
        startDate = Date()
        timer?.fire()
    }

    @objc func didReceiveDistanceNotification(_ receive: Notification) {
        guard let distance = receive.userInfo?["distance"] as? Int else { return }
        self.distance = distance
        self.kcal = Int(Float(distance) * 0.05)
        DispatchQueue.main.async {
            self.summeryDistance.dataLabel.text = String(format: "%.2f", Float(distance)/1000)
            self.summeryKcal.dataLabel.text = "\(self.kcal)"
        }
    }
    
    @IBAction func focusCurrentLocation(_ sender: Any) {
        pathManager.pointResentLocation(location: mapView.userLocation.coordinate)
    }
}
