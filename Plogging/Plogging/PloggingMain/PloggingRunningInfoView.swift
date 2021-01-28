//
// Created by KHU_TAEWOO on 2021/01/29.
//

import Foundation
import UIKit

class PloggingRunningInfoView: UIView{

    // todo: didChangeValue? extract to view controller
    private var summeryData = SummeryData()

    let summery: UIStackView = UIStackView()
    let trashCount: UILabel = {
        let result = UILabel()
        result.textColor = UIColor(cgColor: .fromInt(red: 34, green: 34, blue: 34, alpha: 1))
        result.font.withSize(72)
        result.textAlignment = .center
        return result
    }()
    let trashCountDescription: UILabel = {
        let result = UILabel()
        result.font.withSize(14)
        result.textAlignment = .center
        result.addLineSpacing(height: 18)
        result.addCharacterSpacing(kernValue: -0.34)
        result.text = "모은 쓰레기"
        return result
    }()
    let recordButton: ConfirmButton = {
        let result = ConfirmButton()
        result.setTitle("쓰레기 기록하기", for: .normal)
        return result
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSummery()
        addSubview(summery)
        
        summery.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summery.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            summery.widthAnchor.constraint(equalToConstant: 300),
            summery.heightAnchor.constraint(equalToConstant: 100),
            summery.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func updateSummery() {

    }

    func setupSummery() {
        summery.axis = .vertical
        summery.distribution = .equalSpacing
        let items = [
            makeSummeryItem(to: "킬로미터", value: String(summeryData.distance)),
            makeSummeryItem(to: "진행시간", value: String(summeryData.time)),
            makeSummeryItem(to: "칼로리", value: String(summeryData.kcal)),
        ]

        for item in items {
            summery.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                item.heightAnchor.constraint(equalToConstant: summery.frame.height),
                item.centerYAnchor.constraint(equalTo: summery.centerYAnchor)
            ])
        }

    }

    // todo: extract ..?
    func makeSummeryItem(to unit: String, value: String) -> UIView {
        let result = UIView()
        let dataLabel: UILabel = {
            let result = UILabel()
            result.text = value
            result.textColor = UIColor(cgColor: .fromInt(red: 34, green: 34, blue: 34, alpha: 1))
            result.font.withSize(26)
            result.textAlignment = .center
            result.addCharacterSpacing(kernValue: -0.4)
            return result
        }()
        let unitLabel: UILabel = {
            let result = UILabel()
            result.text = unit
            result.textColor = UIColor(cgColor: .fromInt(red: 137, green: 137, blue: 137, alpha: 1))
            result.font.withSize(14)
            result.textAlignment = .center
            result.addLineSpacing(height: 18)
            result.addCharacterSpacing(kernValue: -0.34)
            return result
        }()

        result.addSubview(dataLabel)
        result.addSubview(unitLabel)

        result.translatesAutoresizingMaskIntoConstraints = false
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dataLabel.topAnchor.constraint(equalTo: result.topAnchor),
            dataLabel.centerXAnchor.constraint(equalTo: result.centerXAnchor),
            unitLabel.bottomAnchor.constraint(equalTo: result.bottomAnchor),
            unitLabel.centerXAnchor.constraint(equalTo: result.centerXAnchor)
        ])

        return result
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

struct SummeryData {
    var distance: Float = 12.34
    var time: String = "56:78"
    var kcal: Int = 987
}



#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct PloggingRunningInfoViewViewRepresentable: UIViewRepresentable {

    typealias UIViewType = PloggingRunningInfoView

    func makeUIView(context: UIViewRepresentableContext<PloggingRunningInfoViewViewRepresentable>) -> UIViewType {
        PloggingRunningInfoView(frame: .init(x: 0, y: 0, width: 300, height: 400))
    }

    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<PloggingRunningInfoViewViewRepresentable>) {

    }
}
struct PloggingRunningInfoViewViewPreview: PreviewProvider {
    static var previews: some View {
        PloggingRunningInfoViewViewRepresentable()
    }
}
#endif
