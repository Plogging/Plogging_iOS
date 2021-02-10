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
    @IBOutlet weak var lineSeparotor: UIView!
    
    func updateUI(_ trashInfo: Trash) {
        var trashTypeName = ""
        switch trashInfo.trashType {
        case 1:
            trashTypeName = TrashType.vinyl.type
        case 2:
            trashTypeName = TrashType.glass.type
        case 3:
            trashTypeName = TrashType.paper.type
        case 4:
            trashTypeName = TrashType.plastic.type
        case 5:
            trashTypeName = TrashType.can.type
        case 6:
            trashTypeName = TrashType.extra.type
        default:
            break
        }
        trashName.text = trashTypeName
        trashCount.text = "\(trashInfo.pickCount)개"
    }
    
    func changeSeparatorColor() {
        lineSeparotor.backgroundColor = UIColor.greenBlue
    }
    
    func pickUpZero() {
        trashName.isHidden = true
        trashCount.isHidden = true
        lineSeparotor.backgroundColor = UIColor.greenBlue
    }
}
