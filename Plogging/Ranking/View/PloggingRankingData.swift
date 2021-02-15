//
//  PloggingRankingData.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/15.
//

import UIKit

class PloggingRankingData: UIView {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!

    override init(frame:CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
//        firstView.clipsToBounds = true
//        firstView.layer.cornerRadius = 12
//        secondView.clipsToBounds = true
//        secondView.layer.cornerRadius = 12
//        thirdView.clipsToBounds = true
//        thirdView.layer.cornerRadius = 12
    }
}
