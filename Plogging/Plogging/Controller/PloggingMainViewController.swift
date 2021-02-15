//
//  PloggingMainViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/20.
//

import UIKit

class PloggingMainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func moveToPloggingResult(_ sender: UIButton) {
        let alert = UIAlertController(title: "플로깅 종료하기", message: "플로깅을 종료하시겠습니까?", preferredStyle: .alert)
        let no = UIAlertAction(title: "아니오", style: .default) { _ in
        }
        let yes = UIAlertAction(title: "네", style: .default) { _ in
            self.dismiss(animated: false, completion: { [self] in
//                let ploggingResultData = createPloggingResultData()
                
                let ploggingResult = UIStoryboard(name: Storyboard.PloggingResult.rawValue, bundle: nil)
                guard let ploggingResultViewController = ploggingResult.instantiateViewController(withIdentifier: "PloggingResultViewController") as? PloggingResultViewController else {
                    return
                }
//                ploggingResultViewController.ploggingResultData = ploggingResultData
                let ploggingResultNavigationController = UINavigationController(rootViewController: ploggingResultViewController)
                ploggingResultNavigationController.modalPresentationStyle = .fullScreen
                ploggingResultNavigationController.modalTransitionStyle = .crossDissolve
                self.rootViewController?.present(ploggingResultNavigationController, animated: false, completion: nil)
            })
        }
        alert.addAction(no)
        alert.addAction(yes)
        present(alert, animated: true, completion: nil)
    }

    func createPloggingResultData() -> PloggingResult {
//        let meta = Meta(userId: nil, createTime: nil, distance: 5, calories: 250, ploggingTime: 7, ploggingImage: nil, ploggingTotalScore: nil, ploggingActivityScore: nil, ploggingEnvironmentScore: nil)
//        let trashList = [Trash(trashType: 1, pickCount: 5), Trash(trashType: 3, pickCount: 4)]
//
//        let ploggingList = PloggingList(id: nil, meta: meta, trashList: trashList)
//
//        return ploggingList
        
        let ploggingResult = PloggingResult(distance: 5, calories: 555, ploggingTime: 600, trashList: [TrashItem(trashType: TrashType.vinyl, pickCount: 3)])
        return ploggingResult
    }
    
}
