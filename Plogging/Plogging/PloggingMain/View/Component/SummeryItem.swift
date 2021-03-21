//
// Created by KHU_TAEWOO on 2021/01/30.
//

import Foundation
import UIKit
class SummeryItem: UIView {

    var data: String? {
        willSet(input) {
            dataLabel.attributedText = NSMutableAttributedString().heavy(input ?? "", fontSize: 26)
        }
    }

    let dataLabel: UILabel = {
        let view = UILabel()
        view.textColor = .getColor(r: 34, g: 34, b: 34, alpha: 1)
        view.textAlignment = .center
        return view
    }()

    let unitLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .init(500))
        view.textColor = .getColor(r: 137, g: 137, b: 137, alpha: 1)
        view.textAlignment = .center
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    func setupView(unit: String, value: String) {
        data = value
        unitLabel.text = unit
        backgroundColor = .clear
    }

    func setupLayout() {

        addSubview(dataLabel)
        addSubview(unitLabel)

        translatesAutoresizingMaskIntoConstraints = false
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dataLabel.topAnchor.constraint(equalTo: topAnchor),
            dataLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dataLabel.bottomAnchor.constraint(equalTo: unitLabel.topAnchor, constant: -16),
            unitLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            unitLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

}
