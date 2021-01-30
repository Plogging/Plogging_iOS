//
//  PloggingMyListCollectionViewCell.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/30.
//

import UIKit

class PloggingMyListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    private func setupUI() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
    }
}
