//
// Created by KHU_TAEWOO on 2021/01/28.
//

import Foundation
import UIKit

class IntroduceModalItem: UIView {

    let label = UILabel()
    let icon = UIImageView()
    let index = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupResource(indexImage: UIImage?, iconImage: UIImage?, text: String) {
        label.text = text
        index.image = indexImage
        icon.image = iconImage
    }

    func setupView() {
        addSubview(label)
        addSubview(icon)
        addSubview(index)
    }

    override func updateConstraints() {
        setupLayout()
        super.updateConstraints()
    }

    func setupLayout() {

        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: centerXAnchor),
            icon.topAnchor.constraint(equalTo: topAnchor),
        ])

        index.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            index.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            index.widthAnchor.constraint(equalToConstant: 34),
            index.heightAnchor.constraint(equalToConstant: 34),
            index.topAnchor.constraint(equalTo: label.topAnchor),
            index.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 66)
        ])

        // todo: - letter space, line height 설정하기
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = UIColor.fromInt(red: 99, green: 110, blue: 127, alpha: 1)
        label.adjustsFontSizeToFitWidth = true

        // label view layout
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: index.trailingAnchor, constant: 12),
        ])
    }


}
