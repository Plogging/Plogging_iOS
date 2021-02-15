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
    
    func updateUI(_ trashInfo: TrashItem) {
        var trashTypeName = ""
        switch trashInfo.trashType {
        case .vinyl:
            trashTypeName = TrashType.vinyl.type
        case .glass:
            trashTypeName = TrashType.glass.type
        case .paper:
            trashTypeName = TrashType.paper.type
        case .plastic:
            trashTypeName = TrashType.plastic.type
        case .can:
            trashTypeName = TrashType.can.type
        case .extra:
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
}
