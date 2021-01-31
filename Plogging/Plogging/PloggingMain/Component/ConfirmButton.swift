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
        
        // todo - shadow 적용하기
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.fromInt(red: 55, green: 213, blue: 172, alpha: 0.67).cgColor
        layer.shadowRadius = 75
        
        // todo - click 이벤트 확인
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

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct ViewRepresentable: UIViewRepresentable {

    typealias UIViewType = ConfirmButton

    func makeUIView(context: UIViewRepresentableContext<ViewRepresentable>) -> UIViewType {
        ConfirmButton()
    }

    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<ViewRepresentable>) {

    }
}
struct ViewPreview: PreviewProvider {
    static var previews: some View {
        ViewRepresentable()
            .padding(10)
    }
}
#endif
