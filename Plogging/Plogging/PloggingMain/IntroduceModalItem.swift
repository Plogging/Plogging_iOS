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
    }

    convenience init(indexImage: UIImage?, iconImage: UIImage?, text: String) {

        self.init(frame: .zero)

        addSubview(label)
        addSubview(icon)
        addSubview(index)

        icon.image = iconImage
        index.image = indexImage
        label.text = text
    }

    func setupLayout() {

        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        icon.centerXAnchor.constraint(equalTo: centerXAnchor),
                                        icon.topAnchor.constraint(equalTo: topAnchor),
//            icon.heightAnchor.constraint(equalToConstant: 122),
//            icon.widthAnchor.constraint(equalToConstant: 132)
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
        label.numberOfLines = 3
        label.textAlignment = .left
        label.font.withSize(14)
        label.textColor = UIColor.init(cgColor: .fromInt(red: 99, green: 110, blue: 127, alpha: 1))

        // label view layout
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20),
                                        label.leadingAnchor.constraint(equalTo: index.trailingAnchor, constant: 12),
                                    ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
