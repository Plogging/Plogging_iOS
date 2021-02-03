//
//  PloggingResultPhotoCell.swift
//  Plogging
//
//  Created by 전소영 on 2021/02/02.
//

import UIKit

class PloggingResultPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var ploggingResultPhoto: UIImageView!
    
    func updateUI(image: UIImage) {
        ploggingResultPhoto.image = image
    }
}
