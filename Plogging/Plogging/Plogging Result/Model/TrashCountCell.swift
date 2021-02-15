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
    
    var trash: Trash? {
        didSet {
            updateUI(trash)
        }
    }
    
    private func updateUI(_ trash: Trash?) {
        guard let trash = trash else {
            return
        }
        var trashTypeName = ""
        switch trash.trashType {
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
        }
        trashName.text = trashTypeName
        trashCount.text = "\(trash.pickCount)개"
    }
    
    func changeSeparatorColor() {
        lineSeparotor.backgroundColor = UIColor.greenBlue
    }
}
