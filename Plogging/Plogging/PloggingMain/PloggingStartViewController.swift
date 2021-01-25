//
// Created by KHU_TAEWOO on 2021/01/24.
//

import Foundation
import UIKit
import MapKit

class PloggingStartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = ConfirmButton()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -133)
        ])
        
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
