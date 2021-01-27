//
//  PloggingIntroduceModalViewController.swift
//  Plogging
//
//  Created by KHU_TAEWOO on 2021/01/26.
//

import UIKit

class PloggingIntroduceModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let components = [
            IntroduceModalItem(indexImage: UIImage(named: "CircleIndex1"),
                               iconImage: UIImage(named: "StartModal1"),
                               text: "쓰레기를 담을 때 사용할 봉투와 집게\n또는 재사용이 가능한 장갑을 준비해주세요."
            ),
            IntroduceModalItem(indexImage: UIImage(named: "RoundIndex2"),
                               iconImage: UIImage(named: "StartModal2"),
                               text: "쓰레기를 담을 때 사용할 봉투와 집게\n또는 재사용이 가능한 장갑을 준비해주세요."
            ),
            IntroduceModalItem(indexImage: UIImage(named: "RoundIndex3"),
                               iconImage: UIImage(named: "StartModal3"),
                               text: "쓰레기를 담을 때 사용할 봉투와 집게\n또는 재사용이 가능한 장갑을 준비해주세요."
            )
        ]

        let stackLayout = UIStackView(arrangedSubviews: components)
        view.addSubview(stackLayout)

        stackLayout.axis = .vertical
        stackLayout.distribution = .fillProportionally
        stackLayout.backgroundColor = .white
        stackLayout.spacing = 48
        view.backgroundColor = .white

        stackLayout.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackLayout.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackLayout.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -73),
            stackLayout.topAnchor.constraint(equalTo: view.topAnchor, constant: 59),
            stackLayout.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackLayout.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        modalPresentationStyle = .automatic

        components.forEach { item in item.setupLayout() }
    }
}


