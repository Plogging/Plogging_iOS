//
//  MyRankingTableViewCell.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/26.
//

import UIKit
import Kingfisher

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

    }
    
    func config(model: UserRankData?) {
        if let model = model {
            if let url = URL(string: model.profileImg){
                profileImageView.kf.setImage(with: url)
            }
            rankLabel.text = "\(model.rank + 1)위"
            scoreLabel.text = "\(model.score)점"
        } else {
            rankLabel.text = "0위"
            if let userImage = PloggingUserData.shared.getUserImage(), let url = URL(string: userImage) {
                profileImageView.kf.setImage(with: url, options: [.forceRefresh])
            } else {
                profileImageView.image = UIImage(named: "user")
            }
            scoreLabel.text = "0점"
        }
    }
    
    @IBAction func clickRankingScoreInfoButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboard.PopUp.rawValue, bundle: nil)
        if let popUpViewController = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController {
            popUpViewController.type = .랭킹점수안내팝업
            popUpViewController.modalPresentationStyle = .overCurrentContext
            self.window?.rootViewController?.present(popUpViewController, animated: false, completion: nil)
        }
    }
}
