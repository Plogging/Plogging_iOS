//
//  RankingPhotoViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/15.
//

import UIKit

class RankingPhotoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
    
    @IBAction func clickCloseButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
