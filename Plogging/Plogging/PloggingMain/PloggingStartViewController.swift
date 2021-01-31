//
// Created by KHU_TAEWOO on 2021/01/24.
//

import Foundation
import UIKit
import MapKit

class PloggingStartViewController: UIViewController {

    @IBOutlet weak var presentIntroduceModal: ConfirmButton!
    
    @IBOutlet weak var dummyItem: PickTrashItem!
    
    @IBAction func presentModal(_ sender: Any) {
        let storyboard = UIStoryboard(name: "PloggingMain", bundle: nil)
        if let infoController = storyboard.instantiateViewController(withIdentifier: "PloggingIntroduceModalViewController") as? PloggingIntroduceModalViewController {
            infoController.isModalInPresentation = true
            present(infoController, animated: true, completion: nil)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dummyItem.setupResource(icon: UIImage(named: "RoundIndex2")!, category: "Hello")
    }
    
}
