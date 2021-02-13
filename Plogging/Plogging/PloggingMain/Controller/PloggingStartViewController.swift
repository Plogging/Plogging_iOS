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
    
    
    func setupView() {
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
        
        currentLocationButton.layer.cornerRadius = currentLocationButton.frame.height/2
        currentLocationButton.backgroundColor = .white
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pathManager = PathManager.pathManager
        pathManager?.setupMapview(on: mapView)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pathManager?.startLocationUpdate()
    }
    
}
