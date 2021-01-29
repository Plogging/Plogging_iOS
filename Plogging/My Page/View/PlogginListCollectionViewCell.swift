//
//  PlogginListCollectionViewCell.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/30.
//

import UIKit

class PlogginListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ploggingImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        ploggingImageView.clipsToBounds = true
        ploggingImageView.layer.cornerRadius = 12
    }

}
