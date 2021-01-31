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
    
    
    var pathManager = PathManager.pathManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    func setupView() {
        summeryDistance.setupView(unit: "킬로미터", value: "100")
        summeryTime.setupView(unit: "분", value: "12:34")
        summeryKcal.setupView(unit: "kcal", value: "399")
        stopButton.backgroundColor = .gray
        stopButton.setTitle("종료", for: .normal)
        
        summeryStackView.layer.cornerRadius = 20
        summeryStackView.backgroundColor = .clear
        
        pathManager.setupMapview(on: mapView)
        pathManager.startRunning()
        
    
        
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
    
    @IBAction func backToStart() {
        pathManager.stopRunning()
        dismiss(animated: true, completion: nil)
    }
    
}
