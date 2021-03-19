//
// Created by KHU_TAEWOO on 2021/01/25.
//

import Foundation
import UIKit

class ConfirmButton: UIButton {

    var title: String? {
        willSet(input) {
            let titleText = NSMutableAttributedString().bold(input ?? "", fontSize: 19)
            setTitleColor(.white, for: .normal)
            setAttributedTitle(titleText, for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupProperties()
        setupLayout()
    }

    func setupProperties() {
        self.backgroundColor = .getColor(r: 55, g: 213, b: 172, alpha: 1)
        self.layer.cornerRadius = 40
    }

    func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: bottomAnchor),
            leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
