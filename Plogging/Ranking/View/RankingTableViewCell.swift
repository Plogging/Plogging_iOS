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
    
    func config(index: IndexPath) {
        if index.row == 0 {
            rankingImageView.image = UIImage(named: "ranking\(index.row + 1)")
            outerView.backgroundColor = UIColor(red: 254/255, green: 229/255, blue: 231/255, alpha: 1)
            profileOuterView.backgroundColor = UIColor(red: 255/255, green: 106/255, blue: 124/255, alpha: 1)
        } else if index.row == 1 {
            rankingImageView.image = UIImage(named: "ranking\(index.row + 1)")
            outerView.backgroundColor = UIColor(red: 213/255, green: 246/255, blue: 233/255, alpha: 1)
            profileOuterView.backgroundColor = UIColor(red: 0/255, green: 184/255, blue: 144/255, alpha: 1)
        } else if index.row == 2 {
            rankingImageView.image = UIImage(named: "ranking\(index.row + 1)")
            outerView.backgroundColor = UIColor(red: 253/255, green: 244/255, blue: 217/255, alpha: 1)
            profileOuterView.backgroundColor = UIColor(red: 255/255, green: 190/255, blue: 0/255, alpha: 1)
        }
    }
}