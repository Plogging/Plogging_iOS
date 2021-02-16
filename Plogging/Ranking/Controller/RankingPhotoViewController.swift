//
//  RankingPhotoViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/15.
//

import UIKit
import Kingfisher

class RankingPhotoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let urlImage = image, let url = URL(string: urlImage) {
            imageView.kf.setImage(with: url)
        }
    }
    
    @IBAction func clickCloseButton(_ sender: UIButton) {
        (rootViewController as? MainViewController)?.setTabBarHidden(false)
        self.dismiss(animated: false, completion: nil)
    }
}
