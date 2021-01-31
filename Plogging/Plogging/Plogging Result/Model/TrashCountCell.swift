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
    
    func updateUI(_ trashInfo: TrashList) {
        var trasTypehName = ""
        switch trashInfo.trashType {
        case 1:
            trasTypehName = "비닐"
        case 2:
            trasTypehName = "유리"
        case 3:
            trasTypehName = "종이"
        case 4:
            trasTypehName = "플라스틱"
        case 5:
            trasTypehName = "캔"
        case 6:
            trasTypehName = "그 외"
        default:
            break
        }
        trashName.text = trasTypehName
        trashCount.text = "\(trashInfo.pickCount)개"
    }
    
    func changeSeparatorColor() {
        lineSeparotor.backgroundColor = UIColor.greenBlue
    }
}
