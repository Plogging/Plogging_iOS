//
//  PickTrashItem.swift
//  Plogging
//
//  Created by KHU_TAEWOO on 2021/02/01.
//

import UIKit


class PickTrashItem: UIView {
    
    private var rootView: UIView?
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBAction func increaseCount() {
        count += 1
    }
    
    @IBAction func decreaseCount() {
        count>0 ? count -= 1 : nil
    }
    
    public var count: Int = 0 {
        didSet {
            countLabel.text = String(count)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXib()
    }
    
    func loadFromXib() {
        let bundle = Bundle.init(for: self.classForCoder)
        let loaded = bundle.loadNibNamed("PickTrashItem", owner: self, options: nil)
        let view = loaded?.first as! UIView
        view.frame = self.bounds
        view.layer.cornerRadius = 12
        addSubview(view)
        rootView = view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    func configView() {
        self.countLabel.text = "\(count)"
    }
    
    func setupResource(icon: UIImage, category: String) {
        self.iconImage.image = icon
        self.categoryLabel.text = category
        self.layer.cornerRadius = 12
    }
}
