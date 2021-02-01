//
//  PloggingPickTrashViewController.swift
//  Plogging
//
//  Created by KHU_TAEWOO on 2021/02/01.
//

import UIKit

class PloggingPickTrashViewController: UIViewController {

    @IBOutlet weak var vinil: PickTrashItem!
    @IBOutlet weak var glass: PickTrashItem!
    @IBOutlet weak var paper: PickTrashItem!
    @IBOutlet weak var plastic: PickTrashItem!
    @IBOutlet weak var can: PickTrashItem!
    @IBOutlet weak var extra: PickTrashItem!
    @IBOutlet weak var confirmButton: ConfirmButton!
    
    @IBAction func saveInput(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
        confirmButton.setTitle("저장", for: .normal)
        confirmButton.layer.cornerRadius = 12
        
        view.backgroundColor = .fromInt(red: 248, green: 250, blue: 252, alpha: 1)
        vinil.setupResource(icon: UIImage(named: "Vinil")!, category: "비닐")
    }
    
    
    
    

}
