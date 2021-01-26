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
        let result = [
            createItem(
                    img: UIImage(named: "StartModal1")!,
                    idx: UIImage(named: "RoundIndex2")!,
                    content: "쓰레기를 담을 때 사용할 봉투와 집게\n또는 재사용이 가능한 장갑을 준비해주세요."
            ),
            createItem(
                    img: UIImage(named: "StartModal2")!,
                    idx: UIImage(named: "RoundIndex2")!,
                    content: "조깅하며 쓰레기를 주워주세요.\n하체운동으로 더 큰 칼로리를 소모할 수 있어요."
            ),
            createItem(
                    img: UIImage(named: "StartModal3")!,
                    idx: UIImage(named: "RoundIndex3")!,
                    content: "플로깅을 마친 후에는,\n모은 쓰레기를 종류별로 분리수거 해주세요."
            )
        ]

        
        let stackLayout = UIStackView(arrangedSubviews: result)
        view.addSubview(stackLayout)
        
        stackLayout.translatesAutoresizingMaskIntoConstraints = false
        stackLayout.axis = .vertical
        stackLayout.distribution = .fillEqually

        NSLayoutConstraint.activate([
            stackLayout.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackLayout.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackLayout.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackLayout.topAnchor.constraint(equalTo: view.topAnchor)
        ])




    }
    
    func createItem(img: UIImage, idx: UIImage, content: String) -> UIView {
        
        let result = UIView()
        let label = UILabel()
        let icon = UIImageView()
        let index = UIImageView()
        
        result.addSubview(label)
        result.addSubview(icon)
        result.addSubview(index)
//        result.backgroundColor = .blue
//        icon.backgroundColor = .orange
//        index.backgroundColor = .brown
        
        result.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            result.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: label.bottomAnchor)
        ])
        

        
        icon.image = img
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: result.centerXAnchor),
            icon.topAnchor.constraint(equalTo: result.topAnchor),
            icon.heightAnchor.constraint(equalToConstant: 122),
            icon.widthAnchor.constraint(equalToConstant: 132)
        ])

        index.image = idx
        index.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            index.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            index.widthAnchor.constraint(equalToConstant: 34),
            index.heightAnchor.constraint(equalToConstant: 34),
            index.leadingAnchor.constraint(equalTo: result.leadingAnchor, constant: 66)
        ])



        // icon view layout
        // todo: - letter space, line height 설정하기


        label.text = content
        label.textColor = .black
        label.numberOfLines = 2
        
        label.textAlignment = .left
        label.font.withSize(14)
        label.textColor = UIColor.init(cgColor: .fromInt(red: 99, green: 110, blue: 127, alpha: 1))

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: index.trailingAnchor, constant: 12),
        ])

        // label view layout
        


        return result
    }

}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)

struct aVCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = PloggingIntroduceModalViewController
    func makeUIViewController(context: Context) -> PloggingIntroduceModalViewController {
        PloggingIntroduceModalViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

struct aPreviews: PreviewProvider {
    static var previews: some View {
        aVCRepresentable()
            .preferredColorScheme(.light)
            .previewLayout(.device)
            .previewDevice("iPhone 12 Pro")
    }
}
#endif
