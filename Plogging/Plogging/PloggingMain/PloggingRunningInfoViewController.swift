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

    var timer: Timer?
    var startDate: Date?
    
    var pathManager = PathManager.pathManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSummeryDataUpdate()
        startUpdate()
    }


    @IBAction func backToStart() {
        pathManager.stopRunning()
        dismiss(animated: true, completion: nil)
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
        guard let distance = receive.userInfo?["distance"] as? Float else { return }
        DispatchQueue.main.async {
            self.summeryDistance.dataLabel.text = String(format: "%.2f", distance)
        }
    }
    
}
