//
//  PloggingIntroduceModalViewController.swift
//  Plogging
//
//  Created by KHU_TAEWOO on 2021/01/26.
//

import UIKit

class PloggingIntroduceModalViewController: UIViewController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @IBOutlet weak var firstItem: IntroduceModalItem!
    @IBOutlet weak var secondItem: IntroduceModalItem!
    @IBOutlet weak var thirdItem: IntroduceModalItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstItem.setupResource(
                indexImage: UIImage(named: "CircleIndex1"),
                iconImage: UIImage(named: "StartModal1"),
                text: "쓰레기를 담을 때 사용할 봉투와 집게\n또는 재사용이 가능한 장갑을 준비해주세요.",
                padding: -73
        )

        secondItem.setupResource(
                indexImage: UIImage(named: "RoundIndex2"),
                iconImage: UIImage(named: "StartModal2"),
                text: "조깅하며 쓰레기를 주워주세요.\n하체운동으로 더 큰 칼로리를 소모할 수 있어요.",
                padding: -55
        )

        thirdItem.setupResource(
                indexImage: UIImage(named: "RoundIndex3"),
                iconImage: UIImage(named: "StartModal3"),
                text: "플로깅을 마친 후에는,\n모은 쓰레기를 종류별로 분리수거 해주세요.",
                padding: -73
        )
    }

}


