//
//  TrashCountCell.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/28.
//

import UIKit

enum Trash {
    case 비닐
    case 유리
    case 종이
    case 플라스틱
    case 캔
    case 그외
    
    var type: String {
        switch self {
        case .비닐:
            return "비닐"
        case .유리:
            return "유리"
        case .종이:
            return "종이"
        case .플라스틱:
            return "플라스틱"
        case .캔:
            return "캔"
        case .그외:
            return "그 외"
        }
    }
}

class TrashCountCell: UICollectionViewCell {
    @IBOutlet weak var trashName: UILabel!
    @IBOutlet weak var trashCount: UILabel!
    @IBOutlet weak var lineSeparotor: UIView!
    
    func updateUI(_ trashInfo: TrashList) {
        var trasTypehName = ""
        switch trashInfo.trash_type {
        case 1:
            trasTypehName = Trash.비닐.type
        case 2:
            trasTypehName = Trash.유리.type
        case 3:
            trasTypehName = Trash.종이.type
        case 4:
            trasTypehName = Trash.플라스틱.type
        case 5:
            trasTypehName = Trash.캔.type
        case 6:
            trasTypehName = Trash.그외.type
        default:
            break
        }
        trashName.text = trasTypehName
        trashCount.text = "\(trashInfo.pick_count)개"
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
