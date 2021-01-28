//
// Created by KHU_TAEWOO on 2021/01/29.
//

import Foundation
import UIKit

class PloggingRunningInfoViewController: UIViewController {

    private var bodyView: PloggingRunningInfoView?

    override func viewDidLoad() {
        super.viewDidLoad()
        bodyView = PloggingRunningInfoView()
        guard let bodyView = bodyView else { return }

        view.addSubview(bodyView)
        
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: view.topAnchor),
            bodyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bodyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)

struct abcdefVCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = PloggingRunningInfoViewController
    func makeUIViewController(context: Context) -> PloggingRunningInfoViewController {
        PloggingRunningInfoViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

struct abcdefPreviews: PreviewProvider {
    static var previews: some View {
        abcdefVCRepresentable()
    }
}
#endif
