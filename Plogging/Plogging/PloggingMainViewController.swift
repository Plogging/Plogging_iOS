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
                let ploggingResult = UIStoryboard(name: "PloggingResult", bundle: nil)
                let ploggingResultNavigationController = ploggingResult.instantiateViewController(identifier: "PloggingResultNavigationController")
                ploggingResultNavigationController.modalPresentationStyle = .fullScreen
                ploggingResultNavigationController.modalTransitionStyle = .crossDissolve
                self.rootViewController?.present(ploggingResultNavigationController, animated: false, completion: nil)
            })
        }
        alert.addAction(no)
        alert.addAction(yes)
        passPloggingResultData()
        present(alert, animated: true, completion: nil)
    }
    
    func passPloggingResultData() {
        let score = PloggingResult.Score(exercise: "\(500)", eco: "100")
        let info = PloggingResult.Info(time: "12:21", distance: "50", calorie: "990")
        let trashInfos = [PloggingResult.TrashInfo(name: "유리", count: "2"),PloggingResult.TrashInfo(name: "비닐", count: "5"),PloggingResult.TrashInfo(name: "그 외", count: "3")]
        
        var ploggingResultData = PloggingResult(score: score, info: info, trashInfos: trashInfos)
        let ploggingResult = UIStoryboard(name: "PloggingResult", bundle: nil)
        guard let ploggingResultViewController = ploggingResult.instantiateViewController(withIdentifier: "PloggingResultViewController") as? PloggingResultViewController else {
            return
        }
//        ploggingResultViewController.ploggingResultData = ploggingResultData
    }
}
