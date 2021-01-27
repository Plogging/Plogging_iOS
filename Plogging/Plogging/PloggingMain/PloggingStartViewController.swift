//
// Created by KHU_TAEWOO on 2021/01/24.
//

import Foundation
import UIKit
import MapKit

class PloggingStartViewController: UIViewController {

    private var button = ConfirmButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        button.addTarget(self, action: #selector(onConfirm), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLayout()
        onConfirm()
    }

    // TODO: life cycle
    func setupLayout() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -133)
        ])
    }

    @objc
    func onConfirm() {
        let controller = PloggingIntroduceModalViewController()
        controller.modalPresentationStyle = .popover
        present(controller, animated: true, completion: nil)
    }
}



#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)

struct VCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = PloggingStartViewController
    func makeUIViewController(context: Context) -> PloggingStartViewController {
        PloggingStartViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct Previews: PreviewProvider {
    static var previews: some View {
        VCRepresentable()
    }
}
#endif
