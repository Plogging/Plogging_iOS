//
//  PloggingResultPhotoCell.swift
//  Plogging
//
//  Created by 전소영 on 2021/02/02.
//

import UIKit
import Kingfisher

class PloggingResultPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var ploggingResultPhoto: UIImageView!
    @IBOutlet weak var createdTime: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var trashCount: UILabel!
    func updateUI(ploggingImageUrl: URL, time: String, scroe: Int, trash: Int) {
        createdTime.text = time
        score.text = String(scroe)
        trashCount.text = String(trash)
        
        ploggingResultPhoto.kf.setImage(with: ploggingImageUrl)
    }
}
