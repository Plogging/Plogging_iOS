//
//  RankingTableViewCell.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/25.
//

import UIKit

class RankingTableViewCell: UITableViewCell {

    @IBOutlet weak var rankingImageView: UIImageView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var profileOuterView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentView.frame = contentView.frame.inset(by: inset)
    }
    
    private func setupUI() {
        outerView.clipsToBounds = true
        outerView.layer.cornerRadius = 12
        
        profileOuterView.clipsToBounds = true
        profileOuterView.layer.cornerRadius = 25

        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 22.5

    }
    
    func config() {
        
    }
}
