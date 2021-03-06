//
//  PloggingPickTrashViewController.swift
//  Plogging
//
//  Created by KHU_TAEWOO on 2021/02/01.
//

import UIKit

class PloggingPickTrashViewController: UIViewController {

    @IBOutlet weak var vinyl: PickTrashItem!
    @IBOutlet weak var glass: PickTrashItem!
    @IBOutlet weak var paper: PickTrashItem!
    @IBOutlet weak var plastic: PickTrashItem!
    @IBOutlet weak var can: PickTrashItem!
    @IBOutlet weak var extra: PickTrashItem!
    @IBOutlet weak var confirmButton: ConfirmButton!
    
    var items: [PickTrashItem]?
    var trashItemList: [TrashItem]?
    
    @IBAction func saveInput(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let trashItemList = self.trashItemList else {return}
        for trashItem in trashItemList {
            let index = trashItem.trashType.rawValue
            items?[index-1].count = trashItem.pickCount
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let destination = presentingViewController as? PloggingRunningInfoViewController {
            var count = 0
            let result = items?.map { item -> TrashItem in
                count += item.count
                return TrashItem(trashType: item.trashType, pickCount: item.count)
            }
            
            destination.count = count
            if let result = result {
                destination.currentTrashList = result
            }
            
            DispatchQueue.main.async {
                destination.updateCount()
            }
        }
    }
    
    override func viewDidLoad() {
        items = [vinyl, glass, paper, plastic, can, extra]
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
        confirmButton.title = "저장"
        confirmButton.layer.cornerRadius = 12

        view.backgroundColor = .getColor(r: 248, g: 250, b: 252, alpha: 1)
        vinyl.setupResource(icon: UIImage(named: "Vinil")!, category: "비닐")
        glass.setupResource(icon: UIImage(named: "glass")!, category: "유리")
        paper.setupResource(icon: UIImage(named: "paper")!, category: "종이")
        plastic.setupResource(icon: UIImage(named: "plastic")!, category: "플라스틱")
        can.setupResource(icon: UIImage(named: "can")!, category: "캔")
        extra.setupResource(icon: UIImage(named: "extra")!, category: "그 외")

    }
    
    
    
    

}
