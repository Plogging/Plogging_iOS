//
// Created by KHU_TAEWOO on 2021/01/24.
//

import Foundation
import UIKit
import MapKit

class PloggingStartViewController: UIViewController {
    
    var pathManager: PathManager?

    @IBOutlet weak var presentIntroduceModal: ConfirmButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func presentModal(_ sender: Any) {
        pathManager?.startRunning()
        let storyboard = UIStoryboard(name: "PloggingMain", bundle: nil)
        if let infoController = storyboard.instantiateViewController(withIdentifier: "PloggingIntroduceModalViewController") as? PloggingIntroduceModalViewController {
            infoController.isModalInPresentation = true
            present(infoController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pathManager = PathManager.pathManager
        pathManager?.setupMapview(on: mapView)
    }
    override func viewDidAppear(_ animated: Bool) {
        pathManager?.startLocationUpdate()
    }
    
}
