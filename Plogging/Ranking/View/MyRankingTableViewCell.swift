//
//  MyRankingTableViewCell.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/26.
//

import UIKit

class MyRankingTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 34.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickRankingScoreInfoButton(_ sender: UIButton) {
    }
    
}
