//
// Created by KHU_TAEWOO on 2021/01/25.
//

import Foundation
import UIKit

class ConfirmButton: UIButton {
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
        setTitle("플로깅 시작하기", for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        backgroundColor = .fromInt(red: 55, green: 213, blue: 172, alpha: 1)

        layer.cornerRadius = 40
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 19)
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
