//
//  PloggingIntroduceModalViewController.swift
//  Plogging
//
//  Created by KHU_TAEWOO on 2021/01/26.
//

import UIKit

class PloggingIntroduceModalViewController: UIViewController {

    private var stackLayout: UIStackView?
    private var components: [IntroduceModalItem] = []
    private var background =  UIView()

    func setupLayout() {

        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])


        guard let stackLayout = stackLayout else { return }
        stackLayout.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackLayout.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            stackLayout.bottomAnchor.constraint(equalTo: background.safeAreaLayoutGuide.bottomAnchor, constant: -73),
            stackLayout.topAnchor.constraint(equalTo: background.topAnchor, constant: 59),
            stackLayout.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            stackLayout.trailingAnchor.constraint(equalTo: background.trailingAnchor)
        ])

    }


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        modalPresentationStyle = .automatic

        background.backgroundColor = .white

        components = [
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

        stackLayout = UIStackView(arrangedSubviews: components)
        guard let stackLayout = stackLayout else { return }
        stackLayout.axis = .vertical
        stackLayout.distribution = .fillProportionally
        stackLayout.backgroundColor = .white
        stackLayout.spacing = 48


        // add sub view
        background.addSubview(stackLayout)
        view.addSubview(background)

        setupLayout()
    }

    override func updateViewConstraints() {
        setupLayout()
        super.updateViewConstraints()
    }
}


