//
//  TrashCountCell.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/28.
//

import UIKit

class TrashCountCell: UICollectionViewCell {
    @IBOutlet weak var trashName: UILabel!
    @IBOutlet weak var trashCount: UILabel!
    
//           trashCountCell?.updateUI(trashInfos[indexPath])
    func updateUI(_ trashInfo: PloggingResult.TrashInfo) {
        trashName.text = trashInfo.name
        trashCount.text = trashInfo.count + "개"
    }
}
