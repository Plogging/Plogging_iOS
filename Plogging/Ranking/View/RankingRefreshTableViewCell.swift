//
//  RankingRefreshTableViewCell.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/30.
//

import UIKit

class RankingRefreshTableViewCell: UITableViewCell {

    weak var delegate: RefreshCellDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        contentView.frame = contentView.frame.inset(by: inset)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func refreshButtonClick(_ sender: UIButton) {
        refreshCollecView()
    }
    
    @IBAction func refreshIconButtonClick(_ sender: UIButton) {
        refreshCollecView()
    }
    
    private func refreshCollecView() {
        delegate?.refreshButtonCall()
    }
}
