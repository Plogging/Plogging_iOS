//
// Created by KHU_TAEWOO on 2021/01/24.
//

import Foundation
import UIKit
import MapKit

class PloggingStartViewController: UIViewController {
    
    var pathManager: PathManager?

    @IBOutlet weak var showIntroduceModalButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var startButton: ConfirmButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pathManager = PathManager.pathManager
        pathManager?.isSetPermissions()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pathManager?.setupMapview(on: mapView)
        pathManager?.startLocationUpdate()
    }
    
    func setupView() {

        currentLocationButton.layer.cornerRadius = currentLocationButton.frame.height/2
        currentLocationButton.backgroundColor = .white

        let title = UILabel()
        title.text = "플로깅 가이드 확인하기"
        title.font.withSize(17)
        title.adjustsFontSizeToFitWidth = true
        showIntroduceModalButton.addSubview(title)

        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: showIntroduceModalButton.topAnchor, constant: 19),
            title.trailingAnchor.constraint(equalTo: showIntroduceModalButton.trailingAnchor, constant: -20)
        ])

        startButton.title = "플로깅 시작하기"
        
        nameLabel.attributedText = NSMutableAttributedString()
            // TODO: user info 연결
            .bold("강태우", fontSize: 17)
            .normal("님 안녕하세요!", fontSize: 17)

    }

    @IBAction func presentIntroduceModal(_ sender: Any) {
        let storyboard = UIStoryboard(name: "PloggingMain", bundle: nil)
        if let infoController = storyboard.instantiateViewController(withIdentifier: "PloggingIntroduceModalViewController")
                as? PloggingIntroduceModalViewController {
            infoController.isModalInPresentation = false
            present(infoController, animated: true, completion: nil)
        }
    }

    @IBAction func focusCurrentLocation(_ sender: Any) {
        pathManager?.pointResentLocation(location: mapView.userLocation.coordinate)
    }
    
}
