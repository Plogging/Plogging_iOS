//
// Created by KHU_TAEWOO on 2021/01/29.
//

import Foundation
import UIKit

class PloggingRunningInfoViewController: UIViewController {

    @IBOutlet weak var summeryStackView: UIStackView!
    @IBOutlet weak var summeryDistance: SummeryItem!
    @IBOutlet weak var summeryTime: SummeryItem!
    @IBOutlet weak var summeryKcal: SummeryItem!
    @IBOutlet weak var continueButton: ConfirmButton!
    @IBOutlet weak var stopButton: ConfirmButton!
    
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
    }
}